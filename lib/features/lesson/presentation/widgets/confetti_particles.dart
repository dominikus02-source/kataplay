import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiParticles extends StatefulWidget {
  final bool play;
  final int particleCount;
  final List<Color> colors;

  const ConfettiParticles({
    super.key,
    this.play = true,
    this.particleCount = 40,
    this.colors = const [
      Color(0xFF6366F1),
      Color(0xFFFBBF24),
      Color(0xFF10B981),
      Color(0xFFEF4444),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ],
  });

  @override
  State<ConfettiParticles> createState() => _ConfettiParticlesState();
}

class _ConfettiParticlesState extends State<ConfettiParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _particles = _generateParticles();
    if (widget.play) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.repeat();
      });
    }
  }

  @override
  void didUpdateWidget(ConfettiParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      _particles = _generateParticles();
      _controller.repeat();
    } else if (!widget.play && oldWidget.play) {
      _controller.stop();
    }
  }

  List<_Particle> _generateParticles() {
    final random = math.Random(42);
    return List.generate(widget.particleCount, (i) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble() * -0.3,
        speedY: 0.004 + random.nextDouble() * 0.008,
        speedX: (random.nextDouble() - 0.5) * 0.004,
        size: 6 + random.nextDouble() * 8,
        rotation: random.nextDouble() * 6.28,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.08,
        color: widget.colors[i % widget.colors.length],
        sway: (random.nextDouble() - 0.5) * 0.006,
        shape: random.nextInt(3),
        delay: random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final elapsed = _controller.value;
        return CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            particles: _particles,
            elapsed: elapsed,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double speedY;
  final double speedX;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final double sway;
  final int shape;
  final double delay;

  _Particle({
    required this.x,
    required this.y,
    required this.speedY,
    required this.speedX,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.sway,
    required this.shape,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double elapsed;

  _ConfettiPainter({
    required this.particles,
    required this.elapsed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (elapsed - p.delay).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final y = (p.y + t * p.speedY * size.height) % (size.height * 1.3);
      final x = p.x * size.width +
          math.sin(t * 20) * p.sway * size.width +
          t * p.speedX * size.width;

      final opacity = (1 - (y / (size.height * 1.3)).clamp(0.0, 1.0));
      final color = p.color.withValues(alpha: opacity);
      final rotation = p.rotation + t * p.rotationSpeed * 20;
      final scale = 1.0;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.scale(scale);

      final paint = Paint()..color = color;

      if (p.shape == 0) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      } else if (p.shape == 1) {
        canvas.drawCircle(Offset.zero, p.size * 0.5, paint);
      } else {
        final path = Path()
          ..moveTo(0, -p.size * 0.5)
          ..lineTo(p.size * 0.5, p.size * 0.3)
          ..lineTo(-p.size * 0.5, p.size * 0.3)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
