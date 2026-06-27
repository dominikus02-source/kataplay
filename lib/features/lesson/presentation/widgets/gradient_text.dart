import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = const LinearGradient(
      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    ),
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
