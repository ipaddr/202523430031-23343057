import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/document_provider.dart';
import '../providers/analysis_provider.dart';
import '../providers/history_provider.dart';
import 'result_screen.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotCtrl;
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;

  int _stepIndex = 0;
  final List<String> _steps = [
    'Membaca dokumen...',
    'Mengidentifikasi klausul...',
    'Menganalisis risiko...',
    'Menyusun laporan...',
  ];

  @override
  void initState() {
    super.initState();

    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _progressAnim = CurvedAnimation(
      parent: _progressCtrl,
      curve: Curves.easeInOut,
    );

    _progressCtrl.addListener(() {
      final val = _progressCtrl.value;
      final newStep = (val * 4).clamp(0, 3).toInt();
      if (newStep != _stepIndex && mounted) {
        setState(() => _stepIndex = newStep);
      }
    });

    // --- mulai animasi + panggil api bersamaan ---
    _progressCtrl.forward().then((_) => _tryNavigate());
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    final doc = context.read<DocumentProvider>();
    final analysis = context.read<AnalysisProvider>();

    await analysis.analyze(
      requestText: doc.requestText,
      cleanedText: doc.cleanedText,
    );

    _tryNavigate();
  }

  void _tryNavigate() {
    final analysis = context.read<AnalysisProvider>();
    // --- navigasi hanya saat animasi & api selesai ---
    if (_progressCtrl.isCompleted && !analysis.isAnalyzing && mounted) {
      _saveAndNavigate(analysis);
    }
  }

  Future<void> _saveAndNavigate(AnalysisProvider analysis) async {
    if (!mounted) return;

    // --- simpan hasil scan ke firestore ---
    if (analysis.isDone) {
      final doc = context.read<DocumentProvider>();
      context.read<HistoryProvider>().saveScan(
        fileName: doc.fileName,
        riskLevel: analysis.highCount >= 3
            ? 2
            : (analysis.highCount >= 1 || analysis.mediumCount >= 3)
            ? 1
            : 0,
        riskScore: analysis.riskScore,
        highCount: analysis.highCount,
        mediumCount: analysis.mediumCount,
        lowCount: analysis.lowCount,
        cleanedText: analysis.cleanedText,
        results: analysis.rawResults,
      );
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, b) => const ResultScreen(),
        transitionsBuilder: (_, a, b, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _rotCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A1929), Color(0xFF0F2540), Color(0xFF1A3C5E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Menganalisis...',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'AI Auklus sedang memproses kontrak Anda\nuntuk mengidentifikasi risiko dan klausul penting.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // --- animasi orb ---
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AuklusColors.accent.withOpacity(0.25),
                              blurRadius: 60,
                            ),
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _rotCtrl,
                        builder: (_, child) => Transform.rotate(
                          angle: _rotCtrl.value * 2 * pi,
                          child: CustomPaint(
                            size: const Size(190, 190),
                            painter: _RingPainter(),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E5080), Color(0xFF0F2540)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: AuklusColors.accent.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          color: AuklusColors.accent,
                          size: 56,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- progress bar ---
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (_, __) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _steps[_stepIndex],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${(_progressAnim.value * 100).toInt()}%',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AuklusColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: _progressAnim.value,
                          minHeight: 8,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AuklusColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // --- indikator langkah ---
                ..._steps.asMap().entries.map((e) {
                  final isDone = e.key < _stepIndex;
                  final isCurrent = e.key == _stepIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AuklusColors.accent.withOpacity(0.15)
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent
                            ? AuklusColors.accent.withOpacity(0.4)
                            : Colors.white10,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle
                              : isCurrent
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isDone
                              ? AuklusColors.riskLow
                              : isCurrent
                              ? AuklusColors.accent
                              : Colors.white24,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          e.value,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isCurrent
                                ? Colors.white
                                : isDone
                                ? Colors.white60
                                : Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        colors: [
          AuklusColors.accent.withOpacity(0.05),
          AuklusColors.accent,
          AuklusColors.accent.withOpacity(0.05),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
