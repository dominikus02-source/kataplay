import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/widgets/character_card.dart';
import 'widgets/animated_stars.dart';
import 'widgets/animated_counter.dart';
import 'widgets/gradient_text.dart';
import 'widgets/confetti_particles.dart';
import 'widgets/floating_bg_shapes.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final int score;
  final int total;
  final int xpEarned;
  final String character;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.xpEarned,
    required this.character,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _bgFade;
  late Animation<Offset> _starsSlide;
  late Animation<Offset> _textSlide;
  late Animation<Offset> _statsSlide;
  late Animation<Offset> _bonusSlide;
  late Animation<Offset> _buttonSlide;
  late Animation<Offset> _characterSlide;
  late Animation<Offset> _scoreSlide;

  bool _countersStarted = false;
  bool _starsReady = false;
  bool _buttonPressed = false;

  bool get isPerfect => widget.score == widget.total;
  double get percentage => widget.total > 0 ? widget.score / widget.total : 1.0;
  int get starRating {
    if (widget.total <= 0) return 0;
    final per = widget.score / widget.total;
    if (per >= 1.0) return 5;
    if (per >= 0.8) return 4;
    if (per >= 0.6) return 3;
    if (per >= 0.4) return 2;
    return 1;
  }

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    _bgFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0, 0.3, curve: Curves.easeOut)),
    );
    _characterSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.05, 0.35, curve: Curves.easeOutCubic)),
    );
    _scoreSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.15, 0.45, curve: Curves.easeOutCubic)),
    );
    _starsSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.25, 0.55, curve: Curves.easeOutCubic)),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic)),
    );
    _statsSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic)),
    );
    _bonusSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic)),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.65, 0.95, curve: Curves.easeOutCubic)),
    );

    _entryController.addListener(() {
      if (_entryController.value >= 0.45 && !_starsReady) {
        setState(() => _starsReady = true);
      }
      if (_entryController.value >= 0.5 && !_countersStarted) {
        setState(() => _countersStarted = true);
      }
    });

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 380;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE0E7FF), Color(0xFFF3E8FF)],
        ),
      ),
      child: Stack(
        children: [
          const FloatingBgShapes(),
          if (_starsReady && isPerfect) const ConfettiParticles(particleCount: 50),
          SafeArea(
            top: true,
            bottom: false,
            child: AnimatedBuilder(
              animation: _entryController,
              builder: (context, child) {
                return Opacity(
                  opacity: _bgFade.value,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: _buildBody(progress, isSmall, size),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ProgressState progress, bool isSmall, Size size) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isSmall ? 8 : 16),
              _buildCharacterSection(isSmall),
              SizedBox(height: isSmall ? 16 : 24),
              _buildScoreSection(isSmall),
              SizedBox(height: isSmall ? 16 : 24),
              _buildStarsSection(isSmall),
              SizedBox(height: isSmall ? 16 : 20),
              _buildTitleSection(isSmall),
              SizedBox(height: isSmall ? 16 : 24),
              _buildGlassmorphismStatsCard(progress, isSmall),
              const SizedBox(height: 16),
              _buildXpBonusCard(progress, isSmall),
              const SizedBox(height: 16),
              if (progress.newlyAwardedBadges.isNotEmpty)
                _buildNewBadges(progress, isSmall),
              SizedBox(height: isSmall ? 20 : 28),
              _buildContinueButton(context, isSmall),
              const SizedBox(height: 10),
              _buildHomeButton(context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterSection(bool isSmall) {
    return SlideTransition(
      position: _characterSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.05 ? 1 : 0,
        child: CharacterCard(
          character: widget.character,
          size: isSmall ? 70 : 90,
          mood: isPerfect ? 'celebrate' : 'happy',
        ),
      ),
    );
  }

  Widget _buildScoreSection(bool isSmall) {
    final scoreSize = isSmall ? 28.0 : 36.0;
    final pctSize = isSmall ? 12.0 : 14.0;

    return SlideTransition(
      position: _scoreSlide,
      child: Container(
        width: isSmall ? 110 : 140,
        height: isSmall ? 110 : 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _countersStarted
                ? AnimatedCounter(
                    target: widget.score,
                    style: TextStyle(
                      fontSize: scoreSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    begin: _countersStarted,
                  )
                : Text(
                    '0',
                    style: TextStyle(
                      fontSize: scoreSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
            Text(
              '/${widget.total}',
              style: TextStyle(
                fontSize: scoreSize * 0.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: isSmall ? 1 : 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: pctSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarsSection(bool isSmall) {
    return SlideTransition(
      position: _starsSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.25 ? 1 : 0,
        child: AnimatedStars(
          score: starRating,
          total: 5,
          starSize: isSmall ? 80 : 100,
        ),
      ),
    );
  }

  Widget _buildTitleSection(bool isSmall) {
    String title;
    List<Color> gradientColors;

    if (isPerfect) {
      title = 'SEMPURNA!';
      gradientColors = const [Color(0xFFFFD700), Color(0xFFFFA500)];
    } else if (percentage >= 0.8) {
      title = 'HEBAT!';
      gradientColors = const [Color(0xFF6366F1), Color(0xFF8B5CF6)];
    } else if (percentage >= 0.6) {
      title = 'BAGUS!';
      gradientColors = const [Color(0xFF10B981), Color(0xFF34D399)];
    } else {
      title = 'AYO COBA LAGI!';
      gradientColors = const [Color(0xFFF59E0B), Color(0xFFF97316)];
    }

    final titleSize = isSmall ? 36.0 : 52.0;

    return SlideTransition(
      position: _textSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.35 ? 1 : 0,
        child: Column(
          children: [
            GradientText(
              title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                height: 1.1,
              ),
              gradient: LinearGradient(colors: gradientColors),
            ),
            if (isPerfect) ...[
              const SizedBox(height: 4),
              Text(
                'Kamu mendapatkan nilai sempurna!',
                style: TextStyle(
                  fontSize: isSmall ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
            ] else if (percentage >= 0.8) ...[
              const SizedBox(height: 4),
              Text(
                'Pertahankan terus!',
                style: TextStyle(
                  fontSize: isSmall ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGlassmorphismStatsCard(ProgressState progress, bool isSmall) {
    return SlideTransition(
      position: _statsSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.45 ? 1 : 0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmall ? 16 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withValues(alpha: 0.5),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF10B981),
                    bgColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                    value: '${_countersStarted ? (widget.score) : 0}',
                    label: 'Benar',
                    isSmall: isSmall,
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    icon: Icons.auto_awesome_rounded,
                    color: const Color(0xFFFBBF24),
                    bgColor: const Color(0xFFFBBF24).withValues(alpha: 0.1),
                    value: '${_countersStarted ? progress.xp : 0}',
                    label: 'XP',
                    isSmall: isSmall,
                  ),
                  _buildDivider(),
                  _buildStatItem(
                    icon: Icons.star_rounded,
                    color: const Color(0xFF8B5CF6),
                    bgColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    value: '$starRating',
                    label: 'Bintang',
                    isSmall: isSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.black.withValues(alpha: 0.06),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String value,
    required String label,
    required bool isSmall,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSmall ? 38 : 44,
          height: isSmall ? 38 : 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: isSmall ? 18 : 22),
        ),
        SizedBox(height: isSmall ? 4 : 6),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmall ? 22 : 28,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1F2937),
            height: 1.1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 11 : 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9CA3AF),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildXpBonusCard(ProgressState progress, bool isSmall) {
    return SlideTransition(
      position: _bonusSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.55 ? 1 : 0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmall ? 16 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF8E1), Color(0xFFFFFDF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isSmall ? 48 : 60,
                height: isSmall ? 48 : 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
              ),
              SizedBox(width: isSmall ? 12 : 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _countersStarted
                          ? AnimatedCounter(
                              target: widget.xpEarned,
                              style: TextStyle(
                                fontSize: isSmall ? 24 : 32,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFB45309),
                                height: 1.1,
                              ),
                              begin: _countersStarted,
                            )
                          : Text(
                              '+0',
                              style: TextStyle(
                                fontSize: isSmall ? 24 : 32,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFB45309),
                                height: 1.1,
                              ),
                            ),
                      Text(
                        ' XP',
                        style: TextStyle(
                          fontSize: isSmall ? 20 : 28,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFB45309),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Total: ${progress.xp} XP',
                      style: TextStyle(
                        fontSize: isSmall ? 10 : 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewBadges(ProgressState progress, bool isSmall) {
    final badges = progress.newlyAwardedBadges.toList();
    return SlideTransition(
      position: _bonusSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.55 ? 1 : 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFBBF24).withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Color(0xFFFBBF24), size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Badge Baru!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...badges.map((id) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _badgeNames[id] ?? id,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, bool isSmall) {
    return SlideTransition(
      position: _buttonSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.65 ? 1 : 0,
        child: GestureDetector(
          onTapDown: (_) {
            if (!_buttonPressed) setState(() => _buttonPressed = true);
          },
          onTapUp: (_) {
            setState(() => _buttonPressed = false);
            context.go('/learning-path');
          },
          onTapCancel: () {
            setState(() => _buttonPressed = false);
          },
          child: AnimatedScale(
            scale: _buttonPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: isSmall ? 56 : 64),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: const Color(0xFF388E3C).withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/learning-path'),
                  borderRadius: BorderRadius.circular(100),
                  splashColor: Colors.white.withValues(alpha: 0.15),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: isSmall ? 14 : 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjut',
                          style: TextStyle(
                            fontSize: isSmall ? 16 : 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: isSmall ? 20 : 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return SlideTransition(
      position: _buttonSlide,
      child: Opacity(
        opacity: _entryController.value >= 0.7 ? 1 : 0,
        child: TextButton(
          onPressed: () => context.go('/home'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            foregroundColor: const Color(0xFF6B7280),
          ),
          child: const Text(
            'Kembali ke Beranda',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  static const Map<String, String> _badgeNames = {
    'level_1_complete': 'Bintang Huruf',
    'level_2_complete': 'Raja Suku Kata',
    'level_3_complete': 'Sahabat Kata',
    'level_4_complete': 'Pembaca Cilik',
    'level_5_complete': 'Juara Kalimat',
    'level_6_complete': 'Pendongeng',
    'xp_100': 'Bintang 1',
    'xp_500': 'Bintang 2',
    'xp_1000': 'Bintang 3',
    'streak_3': 'Streak Api',
    'streak_7': 'Streak Berapi',
    'all_complete': 'Pelajar Hebat',
    'stage_1_complete': 'Perintis Baca',
    'stage_2_complete': 'Pembaca Pemula',
    'stage_3_complete': 'Pencari Kata',
    'stage_4_complete': 'Ahli Baca',
    'stage_5_complete': 'Dekoder',
    'stage_6_complete': 'Penguasa Literasi',
    'stage_7_complete': 'Sultan Literasi',
  };
}
