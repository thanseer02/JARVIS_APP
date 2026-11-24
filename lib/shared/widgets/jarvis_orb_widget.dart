import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';

class JarvisOrbWidget extends StatefulWidget {
  final OrbState state;
  final double size;
  final VoidCallback? onTap;

  const JarvisOrbWidget({
    super.key,
    this.state = OrbState.idle,
    this.size = 240,
    this.onTap,
  });

  @override
  State<JarvisOrbWidget> createState() => _JarvisOrbWidgetState();
}

class _JarvisOrbWidgetState extends State<JarvisOrbWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _updateStateAnimations();
  }

  @override
  void didUpdateWidget(covariant JarvisOrbWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateStateAnimations();
    }
  }

  void _updateStateAnimations() {
    switch (widget.state) {
      case OrbState.idle:
        _rotationController.duration = const Duration(seconds: 12);
        _pulseController.duration = const Duration(milliseconds: 2200);
        break;
      case OrbState.listening:
        _rotationController.duration = const Duration(seconds: 6);
        _pulseController.duration = const Duration(milliseconds: 1000);
        break;
      case OrbState.thinking:
        _rotationController.duration = const Duration(seconds: 2);
        _pulseController.duration = const Duration(milliseconds: 600);
        break;
      case OrbState.speaking:
        _rotationController.duration = const Duration(seconds: 4);
        _pulseController.duration = const Duration(milliseconds: 800);
        break;
      case OrbState.error:
        _rotationController.duration = const Duration(seconds: 1);
        _pulseController.duration = const Duration(milliseconds: 400);
        break;
    }
    if (!_rotationController.isAnimating) _rotationController.repeat();
    if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _pulseController,
          _waveController,
        ]),
        builder: (context, child) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _JarvisOrbPainter(
                state: widget.state,
                rotationAngle: _rotationController.value * 2 * math.pi,
                pulseValue: _pulseController.value,
                waveValue: _waveController.value,
                colors: colors,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _JarvisOrbPainter extends CustomPainter {
  final OrbState state;
  final double rotationAngle;
  final double pulseValue;
  final double waveValue;
  final AppBrandColors colors;

  _JarvisOrbPainter({
    required this.state,
    required this.rotationAngle,
    required this.pulseValue,
    required this.waveValue,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    Color primaryColor;
    Color secondaryColor;

    switch (state) {
      case OrbState.idle:
        primaryColor = colors.cyanAccent;
        secondaryColor = colors.electricBlue;
        break;
      case OrbState.listening:
        primaryColor = colors.neonTeal;
        secondaryColor = colors.cyanAccent;
        break;
      case OrbState.thinking:
        primaryColor = colors.electricBlue;
        secondaryColor = colors.cyanAccent;
        break;
      case OrbState.speaking:
        primaryColor = colors.cyanAccent;
        secondaryColor = Colors.white;
        break;
      case OrbState.error:
        primaryColor = colors.crimsonAlert;
        secondaryColor = colors.amberWarning;
        break;
    }

    // 1. Ambient Holographic Glow Aura
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.35 + (pulseValue * 0.2)),
          secondaryColor.withOpacity(0.12),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glowPaint);

    // 2. Concentric Gyroscopic Rings
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = primaryColor.withOpacity(0.7);

    // Outer Gyro Ring (Rotating Clockwise)
    _drawDashedArc(
      canvas,
      center,
      radius * 0.88,
      rotationAngle,
      math.pi * 1.5,
      ringPaint,
    );
    _drawDashedArc(
      canvas,
      center,
      radius * 0.88,
      rotationAngle + math.pi,
      math.pi * 0.35,
      ringPaint,
    );

    // Mid Gyro Ring (Rotating Counter-Clockwise)
    final midPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = secondaryColor.withOpacity(0.65);

    _drawDashedArc(
      canvas,
      center,
      radius * 0.72,
      -rotationAngle * 1.5,
      math.pi * 1.2,
      midPaint,
    );
    _drawDashedArc(
      canvas,
      center,
      radius * 0.72,
      -rotationAngle * 1.5 + math.pi,
      math.pi * 0.5,
      midPaint,
    );

    // Inner Fast Gyro Ring
    final innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = primaryColor.withOpacity(0.85);

    _drawDashedArc(
      canvas,
      center,
      radius * 0.55,
      rotationAngle * 2.2,
      math.pi * 0.8,
      innerRingPaint,
    );

    // 3. Dynamic Waveforms (when Listening or Speaking)
    if (state == OrbState.listening || state == OrbState.speaking) {
      final wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = primaryColor.withOpacity(0.8);

      final waveRadius = radius * (0.65 + (waveValue * 0.25));
      final opacity = (1.0 - waveValue).clamp(0.0, 1.0);
      wavePaint.color = primaryColor.withOpacity(opacity * 0.75);
      canvas.drawCircle(center, waveRadius, wavePaint);
    }

    // 4. Tactical Radar Crosshairs / Tick Marks
    final tickPaint = Paint()
      ..strokeWidth = 1.4
      ..color = primaryColor.withOpacity(0.5);

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180 + (rotationAngle * 0.3);
      final tickOuter = radius * 0.94;
      final tickInner = (i % 3 == 0) ? radius * 0.84 : radius * 0.89;

      final start = Offset(
        center.dx + tickInner * math.cos(angle),
        center.dy + tickInner * math.sin(angle),
      );
      final end = Offset(
        center.dx + tickOuter * math.cos(angle),
        center.dy + tickOuter * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // 5. High-Energy Glowing Core
    final coreRadius = radius * (0.32 + (pulseValue * 0.08));
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          primaryColor,
          secondaryColor.withOpacity(0.8),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.85, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius));

    canvas.drawCircle(center, coreRadius, corePaint);

    // Subtle Core Boundary
    final coreBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(center, coreRadius * 0.65, coreBorderPaint);
  }

  void _drawDashedArc(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Paint paint,
  ) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _JarvisOrbPainter oldDelegate) => true;
}
