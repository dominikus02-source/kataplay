import 'package:flutter/material.dart';

/// A transparent placeholder image for use in tests where asset images
/// would fail to load. Replaces Image.asset errorBuilder usage.
class TestPlaceholderImage extends StatelessWidget {
  const TestPlaceholderImage({super.key, this.size = 80});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const Placeholder(
        color: Color(0x00000000),
        strokeWidth: 0,
      ),
    );
  }
}

/// Safe asset path matcher — returns true for any known KataPlay asset.
bool isKnownAsset(String path) {
  return path.startsWith('assets/');
}
