import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/history_provider.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _filters = ['Semua', 'Tinggi', 'Sedang', 'Rendah'];
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ScanHistoryItem> _filtered(HistoryProvider history) {
    var list = history.history;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((h) => h.fileName.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final filtered = _filtered(history);

    return Scaffold(
      backgroundColor: AuklusColors.background,
      body: CustomScrollView(
        slivers: [
          // --- header ---
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F2540),
                    Color(0xFF1A3C5E),
                    Color(0xFF1E4976),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Riwayat Scan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${history.totalCount} dokumen telah dianalisis',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- statistik ringkasan ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  _StatChip(
                    label: 'Tinggi',
                    count: history.highCount,
                    color: AuklusColors.riskHigh,
                    bg: AuklusColors.riskHighBg,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    label: 'Sedang',
                    count: history.mediumCount,
                    color: AuklusColors.riskMedium,
                    bg: AuklusColors.riskMediumBg,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    label: 'Rendah',
                    count: history.lowCount,
                    color: AuklusColors.riskLow,
                    bg: AuklusColors.riskLowBg,
                  ),
                ],
              ),
            ),
          ),

          // --- search bar di atas filter ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AuklusColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AuklusColors.border),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  // --- teks gelap agar terbaca ---
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AuklusColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama dokumen...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AuklusColors.textHint,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AuklusColors.textHint,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AuklusColors.textHint,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // --- filter chips ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: _filters.map((f) {
                  final sel = f == history.filterSelected;
                  final isLast = f == _filters.last;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: isLast ? 0 : 8),
                      child: GestureDetector(
                        onTap: () =>
                            context.read<HistoryProvider>().setFilter(f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: sel
                                ? AuklusColors.primary
                                : AuklusColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel
                                  ? AuklusColors.primary
                                  : AuklusColors.border,
                            ),
                          ),
                          child: Text(
                            f,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : AuklusColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // --- daftar atau state kosong ---
          if (history.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AuklusColors.accent),
              ),
            )
          else if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: AuklusColors.textHint.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Tidak ada hasil untuk "$_searchQuery"'
                          : 'Belum ada riwayat scan.',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: AuklusColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                final item = filtered[i];
                return _HistoryCard(
                  item: item,
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      // --- kirim scanid ke resultscreen ---
                      pageBuilder: (_, a, b) => ResultScreen(scanId: item.id),
                      transitionsBuilder: (_, a, b, child) =>
                          FadeTransition(opacity: a, child: child),
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                );
              }, childCount: filtered.length),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// --- chip statistik ---
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
    required this.bg,
  });
  final String label;
  final int count;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- kartu riwayat, tanpa shadow ---
class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.onTap});
  final ScanHistoryItem item;
  final VoidCallback onTap;

  Color get _color {
    switch (item.riskLevel) {
      case 2:
        return AuklusColors.riskHigh;
      case 1:
        return AuklusColors.riskMedium;
      default:
        return AuklusColors.riskLow;
    }
  }

  Color get _bg {
    switch (item.riskLevel) {
      case 2:
        return AuklusColors.riskHighBg;
      case 1:
        return AuklusColors.riskMediumBg;
      default:
        return AuklusColors.riskLowBg;
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AuklusColors.surface,
          borderRadius: BorderRadius.circular(16),
          // --- shadow dihapus ---
          border: Border.all(color: AuklusColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.description_outlined, color: _color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.fileName,
                    style: AuklusTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDate(item.createdAt)} • ${item.highCount + item.mediumCount + item.lowCount} klausul',
                    style: AuklusTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.riskLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AuklusColors.textHint,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
