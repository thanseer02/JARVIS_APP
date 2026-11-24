import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/jarvis_orb_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _bootLog = 'INITIALIZING QUANTUM KERNEL...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _runBootSequence();
  }

  Future<void> _runBootSequence() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _bootLog = 'CALIBRATING HOLOGRAPHIC ARRAY...');

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _bootLog = 'CONNECTING TO JARVIS NEURAL BACKEND...');

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _bootLog = 'JARVIS PROTOCOL ARMED & READY.');

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: Stack(
        children: [
          // Background grid lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(painter: _GridPainter(colors.cyanAccent)),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const JarvisOrbWidget(
                  size: 200,
                  state: OrbState.thinking,
                ),
                const SizedBox(height: 36),
                Text(
                  'J . A . R . V . I . S',
                  style: AppStyles.displayLarge.copyWith(
                    color: colors.textPrimary,
                    letterSpacing: 4.0,
                    shadows: [
                      Shadow(
                        color: colors.cyanAccent,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'JUST A RATHER VERY INTELLIGENT SYSTEM',
                  style: AppStyles.caption.copyWith(
                    color: colors.cyanAccent.withOpacity(0.8),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.bgSecondary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.borderCyan, width: 1),
                  ),
                  child: Text(
                    _bootLog,
                    style: AppStyles.hudMono.copyWith(
                      color: colors.neonTeal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
