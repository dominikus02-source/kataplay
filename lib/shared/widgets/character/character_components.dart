import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features/learning/data/models/question_model.dart';
import '../../theme/app_colors.dart';

/// Resolves character assets with safe fallback
/// If the image file doesn't exist, falls back to emoji
class CharacterAssetResolver {
  CharacterAssetResolver._();

  /// Check if a character's image asset exists
  /// Returns true if the asset is available
  static bool isAssetAvailable(CharacterType character) {
    // In production, this would check AssetManifest
    // For now, we always return false to use emoji fallback
    return false;
  }

  /// Get the display type for a character
  static CharacterDisplayType getDisplayType(CharacterType character) {
    if (isAssetAvailable(character)) {
      return CharacterDisplayType.image;
    }
    return CharacterDisplayType.emoji;
  }
}

enum CharacterDisplayType {
  image,  // Full illustration from asset
  emoji,  // Emoji fallback
}

/// Reusable character illustration widget
/// Handles image loading with emoji fallback
/// Bright modern iOS theme — clean circle with soft shadow
class CharacterIllustration extends StatelessWidget {
  final CharacterType character;
  final double size;
  final String? mood; // Only used for Zelby emoji fallback
  @Deprecated('No longer needed — bright theme is the default')
  final bool isDarkTheme;

  const CharacterIllustration({
    super.key,
    required this.character,
    this.size = 64,
    this.mood,
    this.isDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayType = CharacterAssetResolver.getDisplayType(character);

    if (displayType == CharacterDisplayType.image) {
      return _buildImageAsset(context);
    }
    return _buildEmojiFallback(context);
  }

  Widget _buildImageAsset(BuildContext context) {
    return Image.asset(
      character.assetPath,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        // If image fails to load, fall back to emoji
        return _buildEmojiFallback(context);
      },
    );
  }

  Widget _buildEmojiFallback(BuildContext context) {
    final accentColor = Color(character.colorValue);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          character.emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}

/// Coach bubble messages for each character and context
class CharacterMessages {
  CharacterMessages._();

  /// Greeting when a question starts
  static String getGreeting(CharacterType character) {
    switch (character) {
      case CharacterType.zelby:
        return _pick([
          'Ayo, kamu pasti bisa!',
          'Siap? Ayo mulai!',
          'Zelby percaya sama kamu!',
          'Kamu hebat, ayo buktikan!',
        ]);
      case CharacterType.hazel:
        return _pick([
          'Baca pelan-pelan, ya.',
          'Hazel bantu kamu!',
          'Perhatikan baik-baik, ya.',
          'Kamu bisa, baca dulu!',
        ]);
      case CharacterType.alby:
        return _pick([
          'Dengar baik-baik, lalu pilih jawabannya!',
          'Cepat dan tepat, ayo!',
          'Alby tantang kamu!',
          'Fokus, ya! Kamu pasti bisa!',
        ]);
    }
  }

  /// Encouragement when answer is correct
  static String getCorrectPraise(CharacterType character) {
    switch (character) {
      case CharacterType.zelby:
        return _pick([
          'Wah, keren banget!',
          'Zelby bangga sama kamu!',
          'Hebat! Teruskan!',
          'Kamu semakin pintar!',
        ]);
      case CharacterType.hazel:
        return _pick([
          'Bagus sekali!',
          'Kamu membaca dengan baik!',
          'Pintar! Kamu memahami ceritanya!',
          'Terus membaca, ya!',
        ]);
      case CharacterType.alby:
        return _pick([
          'Cepat dan tepat!',
          'Mantap! Kamu jeli sekali!',
          'Alby kagum sama kamu!',
          'Kamu telinganya tajam!',
        ]);
    }
  }

  /// Comfort when answer is wrong
  static String getWrongComfort(CharacterType character) {
    switch (character) {
      case CharacterType.zelby:
        return _pick([
          'Tidak apa-apa, coba lagi!',
          'Jangan menyerah, ya!',
          'Zelby tetap semangat!',
          'Hampir benar, coba sekali lagi!',
        ]);
      case CharacterType.hazel:
        return _pick([
          'Coba baca lagi pelan-pelan.',
          'Tidak apa-apa, kita belajar bersama!',
          'Perhatikan petunjuknya, ya.',
          'Baca sekali lagi, pasti bisa!',
        ]);
      case CharacterType.alby:
        return _pick([
          'Dengar sekali lagi, ya!',
          'Hampir! Coba perhatikan lagi.',
          'Tidak apa-apa, ayo coba lagi!',
          'Fokus, kamu pasti bisa!',
        ]);
    }
  }

  /// Hint encouragement
  static String getHintEncouragement(CharacterType character) {
    switch (character) {
      case CharacterType.zelby:
        return 'Ini petunjuknya, semoga membantu!';
      case CharacterType.hazel:
        return 'Hazel kasih petunjuk, baca baik-baik ya!';
      case CharacterType.alby:
        return 'Nih, petunjuk dari Alby!';
    }
  }

  static String _pick(List<String> options) {
    // Use a simple hash-based selection for variety
    final now = DateTime.now().millisecondsSinceEpoch;
    return options[now % options.length];
  }
}

/// Character Coach Bubble — a speech bubble paired with a character
/// Used for hints, encouragement, and feedback
/// Bright iOS modern theme — white background with subtle shadow
class CharacterCoachBubble extends StatelessWidget {
  final CharacterType character;
  final String message;
  final double characterSize;
  final bool showCharacter;
  final VoidCallback? onTap;
  @Deprecated('No longer needed — bright theme is the default')
  final bool isDarkTheme;

  const CharacterCoachBubble({
    super.key,
    required this.character,
    required this.message,
    this.characterSize = 48,
    this.showCharacter = true,
    this.onTap,
    this.isDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(character.colorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            if (showCharacter) ...[
              CharacterIllustration(
                character: character,
                size: characterSize,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    character.displayName,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.learningTextPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
