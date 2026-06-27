import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final int target;
  final TextStyle? style;
  final Duration duration;
  final bool begin;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.begin = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.begin) _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.begin && !oldWidget.begin) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = (_animation.value * widget.target).round();
        return Text(
          '$value',
          style: widget.style,
        );
      },
    );
  }
}
