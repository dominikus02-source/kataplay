import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedStars extends StatefulWidget {
  final int score;
  final int total;
  final double starSize;

  const AnimatedStars({
    super.key,
    required this.score,
    required this.total,
    this.starSize = 100,
  });

  @override
  State<AnimatedStars> createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<AnimatedStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnims;
  late List<Animation<double>> _glowAnims;
  late Animation<double> _perfectPulse;

  int get _maxStars => widget.total;
  int get _filledStars => widget.score;
  bool get _isPerfect => widget.score == widget.total;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnims = List.generate(_maxStars, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.2,
            0.3 + i * 0.2,
            curve: Curves.elasticOut,
          ),
        ),
      );
    });

    _glowAnims = List.generate(_maxStars, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.2 + 0.3,
            0.6 + i * 0.2,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _perfectPulse = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _controller.forward();
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_maxStars, (i) {
            return _buildStar(i);
          }),
        );
      },
    );
  }

  Widget _buildStar(int index) {
    final scale = _scaleAnims[index].value;
    final glowValue = _glowAnims[index].value;
    final isFilled = index < _filledStars;

    final glowColor = isFilled
        ? const Color(0xFFFBBF24)
        : Colors.grey.withValues(alpha: 0.2);
    final starColor = isFilled
        ? const Color(0xFFFBBF24)
        : const Color(0xFFD1D5DB);

    final glowRadius = _isPerfect ? 20 + _perfectPulse.value * 10 : 20.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.starSize * 0.04,
      ),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.starSize,
          height: widget.starSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.3 * glowValue),
                blurRadius: glowRadius,
                spreadRadius: 2 * glowValue,
              ),
              BoxShadow(
                color: glowColor.withValues(alpha: 0.2 * glowValue),
                blurRadius: glowRadius * 1.5,
                spreadRadius: 4 * glowValue,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _StarPainter(
              filled: isFilled,
              color: starColor,
              glow: glowValue,
              isPerfect: _isPerfect,
              pulse: _perfectPulse.value,
            ),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final bool filled;
  final Color color;
  final double glow;
  final bool isPerfect;
  final double pulse;

  _StarPainter({
    required this.filled,
    required this.color,
    required this.glow,
    required this.isPerfect,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final path = _createStarPath(center, radius, 5, 0.5);

    if (!filled && glow > 0) {
      final bgPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.grey.withValues(alpha: 0.15);
      canvas.drawPath(path, bgPaint);
    }

    if (isPerfect) {
      final scale = 1 + math.sin(pulse * math.pi * 4) * 0.03;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(scale, scale);
      canvas.translate(-center.dx, -center.dy);
    }

    canvas.drawPath(path, paint);

    if (filled) {
      final shinePaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.5),
            Colors.transparent,
          ],
          radius: 0.4,
        ).createShader(Rect.fromCircle(center: center - const Offset(-4, -4), radius: radius));
      canvas.drawPath(path, shinePaint);
    }
  }

  Path _createStarPath(Offset center, double radius, int points, double innerRatio) {
    final path = Path();
    final angleStep = math.pi / points;

    for (var i = 0; i < points * 2; i++) {
      final angle = -math.pi / 2 + i * angleStep;
      final r = i.isEven ? radius : radius * innerRatio;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_StarPainter old) =>
      old.filled != filled ||
      old.color != color ||
      old.glow != glow ||
      old.isPerfect != isPerfect ||
      old.pulse != pulse;
}
