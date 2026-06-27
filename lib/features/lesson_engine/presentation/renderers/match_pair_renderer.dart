import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class MatchPairRenderer extends StatefulWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const MatchPairRenderer({
    super.key,
    required this.step,
    required this.state,
    required this.onSelect,
  });

  @override
  State<MatchPairRenderer> createState() => _MatchPairRendererState();
}

class _MatchPairRendererState extends State<MatchPairRenderer> {
  String? _selectedLeft;
  final Map<String, String> _matched = {};
  final List<String> _shuffledRights = [];

  @override
  void initState() {
    super.initState();
    _initMatch();
  }

  @override
  void didUpdateWidget(MatchPairRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step.id != widget.step.id) {
      _initMatch();
    }
  }

  void _initMatch() {
    _selectedLeft = null;
    _matched.clear();
    _shuffledRights.clear();
    if (widget.step.matchPairs != null) {
      _shuffledRights.addAll(widget.step.matchPairs!.values.toList()..shuffle());
    }
  }

  void _selectLeft(String key) {
    if (widget.state.status != LessonStatus.playing) return;
    setState(() => _selectedLeft = key);
  }

  void _selectRight(String value) {
    if (_selectedLeft == null || widget.state.status != LessonStatus.playing) return;
    if (_matched.containsValue(value)) return;

    setState(() {
      _matched[_selectedLeft!] = value;
      _selectedLeft = null;
    });

    if (_matched.length == (widget.step.matchPairs?.length ?? 0)) {
      final answers = _matched.values.toList();
      widget.onSelect(answers.join(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.step.matchPairs == null) return const SizedBox();

    final leftItems = widget.step.matchPairs!.keys.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(leftItems.length, (i) {
          final left = leftItems[i];
          final isMatched = _matched.containsKey(left);
          final matchedValue = _matched[left];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildLeftCard(left, i),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: isMatched
                      ? _buildMatchedCard(matchedValue!)
                      : _buildRightCard(i),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLeftCard(String text, int index) {
    final isSelected = _selectedLeft == text;
    return GestureDetector(
      onTap: () => _selectLeft(text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchedCard(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.correctBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.correct, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_rounded, size: 16, color: AppColors.correct),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.correct,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightCard(int index) {
    if (index >= _shuffledRights.length) return const SizedBox();
    final value = _shuffledRights[index];

    return GestureDetector(
      onTap: () => _selectRight(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 1.5),
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
