import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';


class ArrangeWordsQuestion extends StatefulWidget {
  final List<String> wordParts;
  final String correctAnswer;
  final Color accentColor;
  final ValueChanged<bool>? onReadyChanged;

  const ArrangeWordsQuestion({
    super.key,
    required this.wordParts,
    required this.correctAnswer,
    required this.accentColor,
    this.onReadyChanged,
  });

  @override
  State<ArrangeWordsQuestion> createState() => ArrangeWordsQuestionState();
}

class ArrangeWordsQuestionState extends State<ArrangeWordsQuestion>
    with SingleTickerProviderStateMixin {
  late List<String?> _slots;
  late List<_TileItem> _tiles;
  bool _checked = false;
  bool? _isCorrect;
  bool _isReady = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
    _initGame();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _initGame() {
    _slots = List.filled(widget.wordParts.length, null);
    final items = widget.wordParts
        .map((w) => _TileItem(w, false))
        .toList()
      ..shuffle();
    _tiles = items;
    _checked = false;
    _isCorrect = null;
    _isReady = false;
  }

  void reset() {
    setState(_initGame);
  }

  void check() {
    setState(() {
      _checked = true;
      _isCorrect = _slots.join('') == widget.correctAnswer;
    });
    if (_isCorrect == false) {
      _shakeController.forward(from: 0);
    }
  }

  bool get isReady => _isReady;
  bool? get isCorrect => _isCorrect;

  void _onTileTap(String word) {
    if (_checked) return;
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        setState(() {
          _slots[i] = word;
          _tiles = _tiles.map((t) =>
            t.word == word ? _TileItem(t.word, true) : t
          ).toList();
          _isReady = _slots.every((s) => s != null);
          widget.onReadyChanged?.call(_isReady);
        });
        return;
      }
    }
  }

  void _onSlotTap(int index) {
    if (_checked) return;
    final word = _slots[index];
    if (word != null) {
      setState(() {
        _slots[index] = null;
        _tiles = _tiles.map((t) =>
          t.word == word ? _TileItem(t.word, false) : t
        ).toList();
        _isReady = false;
        widget.onReadyChanged?.call(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: _buildSlots(),
        ),
        const SizedBox(height: 16),
        _buildTiles(),
      ],
    );
  }

  Widget _buildSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _checked
              ? (_isCorrect == true ? AppColors.correct.withValues(alpha: 0.3) : AppColors.wrong.withValues(alpha: 0.3))
              : AppColors.primaryBg,
          width: 2,
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(_slots.length, (i) {
          final filled = _slots[i] != null;
          final isSlotCorrect = _checked && filled && _slots[i] == widget.wordParts[i];
          final isSlotWrong = _checked && filled && !isSlotCorrect;
          return GestureDetector(
            onTap: () => _onSlotTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              height: 80,
              decoration: BoxDecoration(
                color: filled
                    ? (isSlotCorrect
                        ? AppColors.correctLight.withValues(alpha: 0.2)
                        : isSlotWrong
                            ? AppColors.wrongLight.withValues(alpha: 0.2)
                            : Colors.white)
                    : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: filled
                      ? (isSlotCorrect
                          ? AppColors.correct
                          : isSlotWrong
                              ? AppColors.wrong
                              : widget.accentColor)
                      : widget.accentColor.withValues(alpha: 0.3),
                  width: filled ? 2.5 : 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                boxShadow: filled && !_checked
                    ? [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.1),
                          blurRadius: 6, offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: filled
                    ? Text(
                        _slots[i]!,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isSlotCorrect
                              ? AppColors.correct
                              : isSlotWrong
                                  ? AppColors.wrong
                                  : AppColors.textPrimary,
                        ),
                      )
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.accentColor.withValues(alpha: 0.3),
                        ),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTiles() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: _tiles.map((tile) {
        final isCorrectTile = _checked && tile.used && _isCorrect == true;
        final isWrongTile = _checked && tile.used && _isCorrect == false;
        return GestureDetector(
          onTap: tile.used ? null : () => _onTileTap(tile.word),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              gradient: tile.used
                  ? LinearGradient(
                      colors: [
                        isCorrectTile ? AppColors.correctLight.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.06),
                        isCorrectTile ? AppColors.correct.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.03),
                      ],
                    )
                  : LinearGradient(
                      colors: [Colors.white, widget.accentColor.withValues(alpha: 0.03)],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: tile.used
                    ? (isCorrectTile
                        ? AppColors.correct
                        : isWrongTile
                            ? AppColors.wrong
                            : Colors.grey.withValues(alpha: 0.15))
                    : widget.accentColor.withValues(alpha: 0.2),
                width: tile.used ? 2 : 2,
              ),
              boxShadow: tile.used
                  ? null
                  : [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.06),
                        blurRadius: 8, offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Opacity(
              opacity: tile.used && !_checked ? 0.3 : 1.0,
              child: Text(
                tile.word,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: tile.used
                      ? (isCorrectTile
                          ? AppColors.correct
                          : isWrongTile
                              ? AppColors.wrong
                              : AppColors.textLight)
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TileItem {
  final String word;
  final bool used;
  const _TileItem(this.word, this.used);
}
