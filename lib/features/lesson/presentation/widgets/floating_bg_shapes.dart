import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingBgShapes extends StatefulWidget {
  const FloatingBgShapes({super.key});

  @override
  State<FloatingBgShapes> createState() => _FloatingBgShapesState();
}

class _FloatingBgShapesState extends State<FloatingBgShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = math.Random(1);
  late List<_BgShape> _shapes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.repeat();
    });
    _shapes = List.generate(8, (i) => _BgShape(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: 40 + _random.nextDouble() * 80,
      speed: 0.002 + _random.nextDouble() * 0.004,
      phase: _random.nextDouble() * 6.28,
      color: [
        const Color(0xFF6366F1),
        const Color(0xFF8B5CF6),
        const Color(0xFFFBBF24),
        const Color(0xFF10B981),
      ][i % 4].withValues(alpha: 0.06 + _random.nextDouble() * 0.04),
    ));
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
        return CustomPaint(
          size: Size.infinite,
          painter: _BgShapesPainter(
            shapes: _shapes,
            time: _controller.value,
          ),
        );
      },
    );
  }
}

class _BgShape {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
  final Color color;

  _BgShape({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.color,
  });
}

class _BgShapesPainter extends CustomPainter {
  final List<_BgShape> shapes;
  final double time;

  _BgShapesPainter({required this.shapes, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in shapes) {
      final t = time * s.speed * 100;
      final x = s.x * size.width + math.sin(t + s.phase) * 30;
      final y = s.y * size.height + math.cos(t * 0.7 + s.phase) * 20;

      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * 0.5 + s.phase);

      if (s.size > 80) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: s.size, height: s.size * 0.6),
            const Radius.circular(20),
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, s.size * 0.5, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BgShapesPainter oldDelegate) => true;
}
