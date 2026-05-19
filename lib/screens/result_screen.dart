import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import '../providers/analysis_provider.dart';
import '../providers/history_provider.dart';

class ResultScreen extends StatefulWidget {
  // --- scanid dari historyscreen, null jika scan baru ---
  const ResultScreen({super.key, this.scanId});
  final String? scanId;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // --- data dari firestore, hanya saat dibuka dari history ---
  bool _loadingFromFirestore = false;
  String? _loadError;
  DateTime? _scanDate;

  @override
  void initState() {
    super.initState();
    if (widget.scanId != null) {
      _loadFromFirestore();
    }
  }

  Future<void> _loadFromFirestore() async {
    setState(() => _loadingFromFirestore = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('scans')
          .doc(widget.scanId)
          .get();

      if (!doc.exists || !mounted) return;

      final data = doc.data()!;
      final ts = data['createdAt'];
      _scanDate = ts is Timestamp ? ts.toDate() : DateTime.now();

      final cleanedText = data['cleanedText'] as String? ?? '';
      final results = (data['results'] as List<dynamic>?) ?? [];

      // --- isi analysis provider dari firestore ---
      context.read<AnalysisProvider>().loadFromHistory(
        cleanedText: cleanedText,
        results: results,
        riskScore: data['riskScore'] as int? ?? 0,
        highCount: data['highCount'] as int? ?? 0,
        mediumCount: data['mediumCount'] as int? ?? 0,
        lowCount: data['lowCount'] as int? ?? 0,
      );
    } catch (e) {
      if (mounted) setState(() => _loadError = 'Gagal memuat data: $e');
    } finally {
      if (mounted) setState(() => _loadingFromFirestore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysis = context.watch<AnalysisProvider>();
    final scanDate = _formatDate(_scanDate ?? DateTime.now());

    // --- loading saat fetch dari firestore ---
    if (_loadingFromFirestore) {
      return Scaffold(
        backgroundColor: AuklusColors.background,
        body: Column(
          children: [
            _buildHeaderWidget(context, scanDate),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AuklusColors.accent),
              ),
            ),
          ],
        ),
      );
    }

    // --- state error ---
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: AuklusColors.background,
        body: Column(
          children: [
            _buildHeaderWidget(context, scanDate),
            Expanded(
              child: Center(
                child: Text(
                  _loadError!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AuklusColors.riskHigh,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AuklusColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeaderWidget(context, scanDate)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- kartu skor risiko ---
                  _RiskScoreCard(analysis: analysis),
                  const SizedBox(height: 20),

                  // --- klausul berisiko ---
                  Text(
                    'Klausul Berisiko',
                    style: AuklusTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  ...analysis.riskClauses.map(
                    (clause) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _RiskClauseCard(clause: clause),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- dokumen lengkap dengan highlight ---
                  Text(
                    'Dokumen Lengkap dengan Highlight',
                    style: AuklusTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AuklusColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AuklusColors.divider),
                    ),
                    // --- justify teks ---
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AuklusColors.textPrimary,
                          height: 1.6,
                        ),
                        children: _buildHighlightSpans(analysis),
                      ),
                    ),
                  ),

                  // --- tombol hapus, hanya jika ada scanid ---
                  if (widget.scanId != null) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteDialog(context),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AuklusColors.riskHigh,
                        ),
                        label: const Text(
                          'Hapus Hasil Analisis',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AuklusColors.riskHigh,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AuklusColors.riskHigh),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Hasil Analisis',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Apakah kamu yakin ingin menghapus hasil analisis ini? Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AuklusColors.textSecondary,
                      side: const BorderSide(color: Color(0xFFCFD8DC)),
                      backgroundColor: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await context.read<HistoryProvider>().deleteScan(
                        widget.scanId!,
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuklusColors.riskHigh,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildHighlightSpans(AnalysisProvider analysis) {
    final segments = analysis.buildHighlightSegments();
    return segments.map((seg) {
      final label = seg['label'] as String?;
      Color bgColor = Colors.transparent;
      if (label == 'clearly_unfair')
        bgColor = Colors.red.withValues(alpha: 0.25);
      if (label == 'potentially_unfair')
        bgColor = Colors.orange.withValues(alpha: 0.25);
      if (label == 'clearly_fair')
        bgColor = Colors.green.withValues(alpha: 0.2);
      return TextSpan(
        text: seg['text'] as String,
        style: label != null ? TextStyle(backgroundColor: bgColor) : null,
      );
    }).toList();
  }

  Widget _buildHeaderWidget(BuildContext context, String scanDate) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2540), Color(0xFF1A3C5E), Color(0xFF1E4976)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'HASIL ANALISIS',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                scanDate,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    return 'Dianalisis pada ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

// --- kartu skor risiko ---
class _RiskScoreCard extends StatefulWidget {
  const _RiskScoreCard({required this.analysis});
  final AnalysisProvider analysis;

  @override
  State<_RiskScoreCard> createState() => _RiskScoreCardState();
}

class _RiskScoreCardState extends State<_RiskScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _fadeAnim = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Color get _labelColor {
    switch (widget.analysis.riskLabel) {
      case 'BAHAYA':
        return AuklusColors.riskHigh;
      case 'PERLU PERHATIAN':
        return AuklusColors.riskMedium;
      default:
        return AuklusColors.riskLow;
    }
  }

  Color get _labelBg {
    switch (widget.analysis.riskLabel) {
      case 'BAHAYA':
        return AuklusColors.riskHighBg;
      case 'PERLU PERHATIAN':
        return AuklusColors.riskMediumBg;
      default:
        return AuklusColors.riskLowBg;
    }
  }

  IconData get _icon {
    switch (widget.analysis.riskLabel) {
      case 'BAHAYA':
        return Icons.dangerous_outlined;
      case 'PERLU PERHATIAN':
        return Icons.warning_amber_rounded;
      default:
        return Icons.verified_user_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AuklusColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // --- ikon status dengan pulse animasi ---
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // --- border pulse, scale up + fade out ---
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (context, _) => Transform.scale(
                    scale: _scaleAnim.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _labelColor.withValues(alpha: _fadeAnim.value),
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
                // --- lingkaran statis + ikon ---
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _labelColor.withValues(alpha: 0.15),
                  ),
                  child: Icon(_icon, color: _labelColor, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Risiko',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _labelBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.analysis.riskLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _labelColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _RiskLegendRow(
                  label: '${widget.analysis.highCount} Risiko Tinggi',
                  color: AuklusColors.riskHigh,
                ),
                const SizedBox(height: 4),
                _RiskLegendRow(
                  label: '${widget.analysis.mediumCount} Risiko Sedang',
                  color: AuklusColors.riskMedium,
                ),
                const SizedBox(height: 4),
                _RiskLegendRow(
                  label: '${widget.analysis.lowCount} Risiko Rendah',
                  color: AuklusColors.riskLow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskLegendRow extends StatelessWidget {
  const _RiskLegendRow({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// --- kartu klausul risiko ---
class _RiskClauseCard extends StatefulWidget {
  const _RiskClauseCard({required this.clause});
  final RiskClause clause;

  @override
  State<_RiskClauseCard> createState() => _RiskClauseCardState();
}

class _RiskClauseCardState extends State<_RiskClauseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _heightFactor;
  late Animation<double> _opacity;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  Color get _color {
    switch (widget.clause.level) {
      case 2:
        return AuklusColors.riskHigh;
      case 1:
        return AuklusColors.riskMedium;
      default:
        return AuklusColors.riskLow;
    }
  }

  Color get _bg {
    switch (widget.clause.level) {
      case 2:
        return AuklusColors.riskHighBg;
      case 1:
        return AuklusColors.riskMediumBg;
      default:
        return AuklusColors.riskLowBg;
    }
  }

  String get _label {
    switch (widget.clause.level) {
      case 2:
        return 'Tinggi';
      case 1:
        return 'Sedang';
      default:
        return 'Rendah';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AuklusColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded
              ? _color.withValues(alpha: 0.3)
              : AuklusColors.divider,
          width: _expanded ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // --- header ---
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.clause.level == 2
                          ? Icons.warning_amber_rounded
                          : widget.clause.level == 1
                          ? Icons.info_outline
                          : Icons.check_circle_outline,
                      color: _color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.clause.article,
                          style: AuklusTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _bg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Risiko $_label',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AuklusColors.textHint,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- konten expand, cliprect + heightfactor ---
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) => ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: Opacity(opacity: _opacity.value, child: child),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: _color.withValues(alpha: 0.2), height: 16),
                  Text(
                    widget.clause.description,
                    textAlign: TextAlign.justify,
                    style: AuklusTextStyles.bodyMedium.copyWith(
                      color: AuklusColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AuklusColors.accent.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AuklusColors.accent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      widget.clause.advice,
                      textAlign: TextAlign.justify,
                      style: AuklusTextStyles.bodyMedium.copyWith(
                        color: AuklusColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
