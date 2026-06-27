import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/lesson_step.dart';
import '../../application/lesson_state.dart';

class WordOrderRenderer extends StatefulWidget {
  final LessonStep step;
  final LessonState state;
  final Function(String) onSelect;

  const WordOrderRenderer({
    super.key,
    required this.step,
    required this.state,
    required this.onSelect,
  });

  @override
  State<WordOrderRenderer> createState() => _WordOrderRendererState();
}

class _WordOrderRendererState extends State<WordOrderRenderer> {
  List<String> _available = [];
  List<String> _placed = [];

  @override
  void initState() {
    super.initState();
    _available = List<String>.from(widget.step.choices)..shuffle();
    _placed = [];
  }

  @override
  void didUpdateWidget(WordOrderRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step.id != widget.step.id) {
      _available = List<String>.from(widget.step.choices)..shuffle();
      _placed = [];
    }
  }

  void _placeLetter(String letter) {
    setState(() {
      _available.remove(letter);
      _placed.add(letter);
    });
    widget.onSelect(_placed.join(''));
  }

  void _removeLetter(String letter) {
    setState(() {
      _placed.remove(letter);
      _available.add(letter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryBg.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _placed.asMap().entries.map((entry) {
              final i = entry.key;
              final letter = entry.value;
              final showFeedback = widget.state.status == LessonStatus.feedback;
              final isCorrect = showFeedback &&
                  i < widget.step.correctAnswer.length &&
                  letter == widget.step.correctAnswer[i];

              return GestureDetector(
                onTap: widget.state.status == LessonStatus.playing
                    ? () => _removeLetter(letter)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: showFeedback
                        ? (isCorrect
                            ? AppColors.correctBg
                            : AppColors.wrongBg)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: showFeedback
                          ? (isCorrect ? AppColors.correct : AppColors.wrong)
                          : AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: showFeedback
                            ? (isCorrect
                                ? AppColors.correct
                                : AppColors.wrong)
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _available.map((letter) {
            return GestureDetector(
              onTap: widget.state.status == LessonStatus.playing
                  ? () => _placeLetter(letter)
                  : null,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.step.hint != null && widget.state.status == LessonStatus.playing) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.step.hint!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.goldDark,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
