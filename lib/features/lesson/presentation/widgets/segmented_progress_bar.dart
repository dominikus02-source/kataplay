import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatelessWidget {
  final int totalSegments;
  final int currentIndex;
  final int completedCount;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;

  const SegmentedProgressBar({
    super.key,
    required this.totalSegments,
    required this.currentIndex,
    this.completedCount = 0,
    this.activeColor = const Color(0xFF6366F1),
    this.completedColor = const Color(0xFF10B981),
    this.inactiveColor = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSegments, (i) {
        final isCompleted = i < completedCount;
        final isActive = i == currentIndex && !isCompleted;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 3,
              right: i == totalSegments - 1 ? 0 : 3,
            ),
            child: _Segment(
              isCompleted: isCompleted,
              isActive: isActive,
              activeColor: activeColor,
              completedColor: completedColor,
              inactiveColor: inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}

class _Segment extends StatefulWidget {
  final bool isCompleted;
  final bool isActive;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;

  const _Segment({
    required this.isCompleted,
    required this.isActive,
    required this.activeColor,
    required this.completedColor,
    required this.inactiveColor,
  });

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );
    if (widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pulseController.repeat(reverse: true);
      });
    }
  }

  @override
  void didUpdateWidget(_Segment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isCompleted
        ? widget.completedColor
        : widget.isActive
            ? widget.activeColor
            : widget.inactiveColor;

    if (!widget.isActive) {
      return _buildSegment(color, 1.0);
    }

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return _buildSegment(
          color,
          _pulseAnim.value,
        );
      },
    );
  }

  Widget _buildSegment(Color color, double opacity) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      height: 6,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(3),
        boxShadow: widget.isActive
            ? [
                BoxShadow(
                  color: widget.activeColor.withValues(alpha: 0.2 * opacity),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
    );
  }
}
