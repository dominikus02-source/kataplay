import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.height = 20,
    this.width,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: const [
                Color(0xFFF3F4F6),
                Color(0xFFE5E7EB),
                Color(0xFFF3F4F6),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
            ),
          ),
        );
      },
    );
  }
}

class LessonSkeleton extends StatelessWidget {
  const LessonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const ShimmerLoading(height: 6, borderRadius: 3),
          const SizedBox(height: 32),
          const ShimmerLoading(height: 80, width: 80, borderRadius: 40),
          const SizedBox(height: 16),
          const ShimmerLoading(height: 24, width: 200),
          const SizedBox(height: 8),
          const ShimmerLoading(height: 16, width: 160),
          const SizedBox(height: 32),
          const ShimmerLoading(height: 72, borderRadius: 18),
          const SizedBox(height: 12),
          const ShimmerLoading(height: 72, borderRadius: 18),
          const SizedBox(height: 12),
          const ShimmerLoading(height: 72, borderRadius: 18),
          const SizedBox(height: 12),
          const ShimmerLoading(height: 72, borderRadius: 18),
        ],
      ),
    );
  }
}
