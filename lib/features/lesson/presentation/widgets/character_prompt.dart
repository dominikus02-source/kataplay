import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../shared/widgets/character_card.dart';

class CharacterPrompt extends StatelessWidget {
  final String character;
  final String message;
  final String mood;
  final double characterSize;

  const CharacterPrompt({
    super.key,
    required this.character,
    required this.message,
    this.mood = 'idle',
    this.characterSize = AppDimensions.characterSizeXs,
  });

  Color get _accentColor => AppColors.characterColor(character);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                width: characterSize + 16,
                height: characterSize + 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentColor.withValues(alpha: 0.06),
                ),
              ),
              Positioned(
                left: 8, top: 8,
                child: CharacterCard(
                  character: character,
                  size: characterSize,
                  showName: false,
                  mood: mood,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _accentColor.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
                Positioned(
                  left: -6,
                  bottom: 14,
                  child: Transform.rotate(
                    angle: -0.7854,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: _accentColor.withValues(alpha: 0.1), width: 1.5),
                          bottom: BorderSide(color: _accentColor.withValues(alpha: 0.1), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
