import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../core/utils/character_assets.dart';

class CharacterCard extends StatelessWidget {
  final String character;
  final double size;
  final bool showName;
  final String mood;

  const CharacterCard({
    super.key,
    required this.character,
    this.size = AppConstants.characterSize,
    this.showName = true,
    this.mood = 'idle',
  });

  @override
  Widget build(BuildContext context) {
    final assetPath =
        CharacterAssets.getImageForCharacter(character, mood: mood);
    final charColor = AppColors.characterColor(character);
    final bgColor = AppColors.characterBg(character);
    final name = AppConstants.characterName(character);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 1.5,
          height: size * 1.25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                bgColor,
                bgColor.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size * 0.6),
              topRight: Radius.circular(size * 0.6),
              bottomLeft: Radius.circular(size * 0.5),
              bottomRight: Radius.circular(size * 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: charColor.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: charColor.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -size * 0.3,
                right: -size * 0.2,
                child: Container(
                  width: size * 0.8,
                  height: size * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: charColor.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          _getFallbackIcon(character),
                          size: size * 0.5,
                          color: charColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  charColor.withValues(alpha: 0.12),
                  charColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: charColor.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Text(
              name,
              style: TextStyle(
                fontSize: size * 0.12,
                fontWeight: FontWeight.w700,
                color: charColor,
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getFallbackIcon(String character) {
    switch (character.toLowerCase()) {
      case 'zelby':
        return Icons.smart_toy_rounded;
      case 'hazel':
        return Icons.pets_rounded;
      case 'alby':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.smart_toy_rounded;
    }
  }
}
