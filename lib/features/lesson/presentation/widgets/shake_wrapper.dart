import 'package:flutter/material.dart';

class ShakeWrapper extends StatefulWidget {
  final Widget child;
  final int triggerCount;
  final bool isShake;
  final VoidCallback? onComplete;

  const ShakeWrapper({
    super.key,
    required this.child,
    this.triggerCount = 0,
    this.isShake = true,
    this.onComplete,
  });

  @override
  State<ShakeWrapper> createState() => _ShakeWrapperState();
}

class _ShakeWrapperState extends State<ShakeWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeOffset;
  late Animation<double> _scaleBounce;
  int _lastTriggerCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4, end: -2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -2, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _lastTriggerCount = widget.triggerCount;
  }

  @override
  void didUpdateWidget(ShakeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerCount != _lastTriggerCount) {
      _lastTriggerCount = widget.triggerCount;
      _controller.forward(from: 0).then((_) {
        widget.onComplete?.call();
      });
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
      animation: _controller,
      builder: (context, child) {
        if (_controller.isAnimating && widget.isShake) {
          return Transform.translate(
            offset: Offset(_shakeOffset.value, 0),
            child: child,
          );
        }
        if (_controller.isAnimating && !widget.isShake) {
          return Transform.scale(
            scale: _scaleBounce.value,
            child: child,
          );
        }
        return child ?? const SizedBox.shrink();
      },
      child: widget.child,
    );
  }
}
