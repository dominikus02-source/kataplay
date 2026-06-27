import 'package:flutter/material.dart';

class LessonBottomAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final IconData? icon;
  final bool isSuccess;
  final bool isDanger;

  const LessonBottomAction({
    super.key,
    required this.label,
    this.onPressed,
    this.isDisabled = false,
    this.icon,
    this.isSuccess = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding + 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isDisabled
                ? const Color(0xFFE5E7EB)
                : isSuccess
                    ? const Color(0xFF24C96B)
                    : isDanger
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF24C96B),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: (isSuccess || (!isDanger) ? const Color(0xFF24C96B) : const Color(0xFFFF6B6B)).withValues(alpha: 0.25),
                      blurRadius: 12, offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onPressed,
              borderRadius: BorderRadius.circular(28),
              splashColor: Colors.white.withValues(alpha: 0.2),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDisabled ? const Color(0xFF9CA3AF) : Colors.white,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, color: isDisabled ? const Color(0xFF9CA3AF) : Colors.white, size: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
