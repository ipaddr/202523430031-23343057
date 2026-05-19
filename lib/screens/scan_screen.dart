import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/document_provider.dart';
import '../providers/history_provider.dart';
import 'extracted_text_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AuklusColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AuklusColors.textPrimary,
              ),
              title: const Text(
                'Kamera',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AuklusColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _startProcess(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AuklusColors.textPrimary,
              ),
              title: const Text(
                'Galeri',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AuklusColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _startProcess(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.picture_as_pdf,
                color: AuklusColors.textPrimary,
              ),
              title: const Text(
                'Dokumen PDF',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AuklusColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _startPdfProcess(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startProcess(BuildContext context, ImageSource source) async {
    final doc = context.read<DocumentProvider>();
    doc.reset();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExtractedTextScreen()),
    );
    await doc.processImage(source);
  }

  Future<void> _startPdfProcess(BuildContext context) async {
    final doc = context.read<DocumentProvider>();
    doc.reset();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExtractedTextScreen()),
    );
    await doc.processPdf();
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final recentScans = history.history.take(3).toList();

    return Scaffold(
      backgroundColor: AuklusColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildUploadZone(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Scan Terakhir', style: AuklusTextStyles.headlineMedium),
                  TextButton(
                    // --- navigasi ke tab riwayat ---
                    onPressed: widget.onViewAll,
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AuklusColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (history.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AuklusColors.accent,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else if (recentScans.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Text(
                  'Belum ada scan. Upload kontrak pertama Anda!',
                  style: AuklusTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _ScanCard(item: recentScans[i]),
                ),
                childCount: recentScans.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AuklusColors.accent,
                          AuklusColors.primaryLight,
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icon/appicon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Auklus',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan Kontrak',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Unggah dokumen untuk analisis otomatis.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadZone(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUploadOptions(context),
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: AuklusColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AuklusColors.accent.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AuklusColors.accent.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AuklusColors.accentGradient,
                boxShadow: [
                  BoxShadow(
                    color: AuklusColors.accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Upload Kontrak',
              style: AuklusTextStyles.titleLarge.copyWith(
                color: AuklusColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'PDF atau Foto dokumen (Maks. 20MB)',
              style: AuklusTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FileTypeChip(label: 'PDF', icon: Icons.picture_as_pdf),
                const SizedBox(width: 8),
                _FileTypeChip(label: 'JPG', icon: Icons.image_outlined),
                const SizedBox(width: 8),
                _FileTypeChip(label: 'PNG', icon: Icons.image_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({required this.item});
  final ScanHistoryItem item;

  Color get _riskColor {
    switch (item.riskLevel) {
      case 2:
        return AuklusColors.riskHigh;
      case 1:
        return AuklusColors.riskMedium;
      default:
        return AuklusColors.riskLow;
    }
  }

  Color get _riskBg {
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
    return Container(
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AuklusColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AuklusColors.primary,
              size: 24,
            ),
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
                  _formatDate(item.createdAt),
                  style: AuklusTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _riskBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.riskLabel,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _riskColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileTypeChip extends StatelessWidget {
  const _FileTypeChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AuklusColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AuklusColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AuklusColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AuklusColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
