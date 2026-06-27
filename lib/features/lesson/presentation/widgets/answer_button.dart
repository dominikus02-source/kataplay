import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class AnswerButton extends StatefulWidget {
  final String label;
  final bool isCorrect;
  final bool isSelected;
  final bool showFeedback;
  final VoidCallback onTap;
  final int optionIndex;

  const AnswerButton({
    super.key,
    required this.label,
    required this.isCorrect,
    required this.isSelected,
    required this.showFeedback,
    required this.onTap,
    this.optionIndex = 0,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (!widget.showFeedback) return const Color(0xFFF7F8FA);
    if (widget.isCorrect && widget.isSelected) return const Color(0xFFDDFBEA);
    if (widget.isSelected && !widget.isCorrect) return const Color(0xFFFFF3D6);
    if (widget.isCorrect) return const Color(0xFFDDFBEA);
    return const Color(0xFFF7F8FA);
  }

  Color get _borderColor {
    if (!widget.showFeedback) return const Color(0xFFE5E7EB);
    if (widget.isCorrect) return const Color(0xFF24C96B);
    if (widget.isSelected) return const Color(0xFFFFB545);
    return const Color(0xFFE5E7EB);
  }

  Color get _textColor {
    if (!widget.showFeedback) return const Color(0xFF263238);
    if (widget.isCorrect && widget.isSelected) return Colors.white;
    if (widget.isSelected && !widget.isCorrect) return const Color(0xFFFFB545);
    if (widget.isCorrect) return const Color(0xFF24C96B);
    return const Color(0xFF263238);
  }

  @override
  Widget build(BuildContext context) {
    final showIcon = widget.showFeedback && widget.isSelected;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _borderColor,
              width: widget.showFeedback && widget.isSelected ? 2.5 : 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.showFeedback && widget.isSelected
                      ? Colors.transparent
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: showIcon
                      ? Icon(
                          widget.isCorrect
                              ? Icons.check_rounded
                              : Icons.close_rounded,
                          color: widget.isCorrect
                              ? AppColors.textOnPrimary
                              : AppColors.textOnPrimary,
                          size: 18,
                        )
                      : Text(
                          String.fromCharCode(65 + widget.optionIndex),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _textColor,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
