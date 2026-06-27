import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AnswerState { default_, selected, correct, incorrect }

class AnswerOptionCard extends StatefulWidget {
  final String text;
  final int index;
  final AnswerState state;
  final VoidCallback? onTap;
  final bool showIcon;

  const AnswerOptionCard({
    super.key,
    required this.text,
    required this.index,
    this.state = AnswerState.default_,
    this.onTap,
    this.showIcon = true,
  });

  @override
  State<AnswerOptionCard> createState() => _AnswerOptionCardState();
}

class _AnswerOptionCardState extends State<AnswerOptionCard>
    with TickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _tapScale;
  late AnimationController _shakeController;
  late Animation<double> _shakeOffset;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
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
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnswerOptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tapController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.state != AnswerState.default_) return;
    _tapController.forward();
  }

  void _handleTapUp(_) {
    if (widget.state != AnswerState.default_) return;
    _tapController.reverse();
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (widget.state != AnswerState.default_) return;
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final isInteractive = widget.state == AnswerState.default_;

    return GestureDetector(
      onTapDown: isInteractive ? _handleTapDown : null,
      onTapUp: isInteractive ? _handleTapUp : null,
      onTapCancel: isInteractive ? _handleTapCancel : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_tapController, _shakeController]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeOffset.value, 0),
            child: Transform.scale(
              scale: _tapScale.value,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 68),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colors.border,
                    width: colors.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (widget.showIcon && colors.leadingIcon != null) ...[
                      Icon(
                        colors.leadingIcon,
                        color: colors.leadingIconColor,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (colors.trailingIcon != null) ...[
                      const SizedBox(width: 10),
                      Icon(
                        colors.trailingIcon,
                        color: colors.trailingIconColor,
                        size: 22,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _CardColors _getColors() {
    switch (widget.state) {
      case AnswerState.correct:
        return _CardColors(
          bg: const Color(0xFFD1FAE5),
          border: const Color(0xFF10B981),
          borderWidth: 2.5,
          text: const Color(0xFF065F46),
          shadow: const Color(0xFF10B981).withValues(alpha: 0.1),
          leadingIcon: Icons.check_circle_rounded,
          leadingIconColor: const Color(0xFF10B981),
          trailingIcon: null,
          trailingIconColor: Colors.transparent,
        );
      case AnswerState.incorrect:
        return _CardColors(
          bg: const Color(0xFFFEE2E2),
          border: const Color(0xFFEF4444),
          borderWidth: 2.5,
          text: const Color(0xFF991B1B),
          shadow: const Color(0xFFEF4444).withValues(alpha: 0.1),
          leadingIcon: null,
          leadingIconColor: Colors.transparent,
          trailingIcon: Icons.cancel_rounded,
          trailingIconColor: const Color(0xFFEF4444),
        );
      case AnswerState.selected:
        return _CardColors(
          bg: const Color(0xFFEEF2FF),
          border: const Color(0xFF6366F1),
          borderWidth: 2.5,
          text: const Color(0xFF312E81),
          shadow: const Color(0xFF6366F1).withValues(alpha: 0.12),
          leadingIcon: null,
          leadingIconColor: Colors.transparent,
          trailingIcon: null,
          trailingIconColor: Colors.transparent,
        );
      case AnswerState.default_:
        return _CardColors(
          bg: const Color(0xFFF9FAFB),
          border: const Color(0xFFE5E7EB),
          borderWidth: 1.5,
          text: const Color(0xFF1F2937),
          shadow: Colors.black.withValues(alpha: 0.04),
          leadingIcon: null,
          leadingIconColor: Colors.transparent,
          trailingIcon: null,
          trailingIconColor: Colors.transparent,
        );
    }
  }
}

class _CardColors {
  final Color bg;
  final Color border;
  final double borderWidth;
  final Color text;
  final Color shadow;
  final IconData? leadingIcon;
  final Color leadingIconColor;
  final IconData? trailingIcon;
  final Color trailingIconColor;

  _CardColors({
    required this.bg,
    required this.border,
    required this.borderWidth,
    required this.text,
    required this.shadow,
    this.leadingIcon,
    this.leadingIconColor = Colors.transparent,
    this.trailingIcon,
    this.trailingIconColor = Colors.transparent,
  });
}
