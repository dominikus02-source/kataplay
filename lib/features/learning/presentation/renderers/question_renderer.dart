import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/question_model.dart';

/// Main question renderer that delegates to type-specific sub-renderers
/// Supports all 10 question types with consistent visual style
class QuestionRenderer extends StatelessWidget {
  final Question question;
  final Function(String) onAnswer;
  final Function(String) onTextAnswer;
  final Function(List<int>) onSequenceAnswer;

  const QuestionRenderer({
    super.key,
    required this.question,
    required this.onAnswer,
    required this.onTextAnswer,
    required this.onSequenceAnswer,
  });

  @override
  Widget build(BuildContext context) {
    try {
      switch (question.questionType) {
        case QuestionType.multipleChoice:
          return _MultipleChoiceRenderer(
            question: question,
            onAnswer: onAnswer,
          );

        case QuestionType.trueFalse:
          return _TrueFalseRenderer(
            question: question,
            onAnswer: onAnswer,
          );

        case QuestionType.matchWordImage:
          return _MatchWordImageRenderer(
            question: question,
            onAnswer: onAnswer,
          );

        case QuestionType.listenAndChoose:
          return _ListenAndChooseRenderer(
            question: question,
            onAnswer: onAnswer,
          );

        case QuestionType.fillInTheBlank:
          return _FillInTheBlankRenderer(
            question: question,
            onAnswer: onAnswer,
            onTextAnswer: onTextAnswer,
          );

        case QuestionType.arrangeWords:
          return _ArrangeWordsRenderer(
            question: question,
            onSequenceAnswer: onSequenceAnswer,
          );

        case QuestionType.pickCorrectImage:
          return _PickCorrectImageRenderer(
            question: question,
            onAnswer: onAnswer,
          );

        case QuestionType.dragAndDrop:
          return _DragAndDropRenderer(
            question: question,
            onAnswer: onAnswer,
          );

        case QuestionType.orderStory:
          return _OrderStoryRenderer(
            question: question,
            onSequenceAnswer: onSequenceAnswer,
          );

        case QuestionType.pickInitialLetter:
          return _PickInitialLetterRenderer(
            question: question,
            onAnswer: onAnswer,
          );
      }
    } catch (e) {
      // Safe fallback — never crash on render
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Soal ini belum tersedia. Lewati ke soal berikutnya.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      );
    }
  }
}

// ============================================================
// SHARED: Answer Option Button
// ============================================================

class _AnswerOptionButton extends StatefulWidget {
  final AnswerOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLarge; // For true/false and letter options

  const _AnswerOptionButton({
    required this.option,
    this.isSelected = false,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  State<_AnswerOptionButton> createState() => _AnswerOptionButtonState();
}

class _AnswerOptionButtonState extends State<_AnswerOptionButton> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final option = widget.option;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_scale),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isLarge ? 24 : 16,
          vertical: widget.isLarge ? 18 : 14,
        ),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(widget.isLarge ? 20 : 16),
          border: Border.all(
            color: widget.isSelected
                ? AppColors.primary
                : AppColors.surfaceVariant,
            width: widget.isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            if (option.emoji != null) ...[
              Text(
                option.emoji!,
                style: TextStyle(fontSize: widget.isLarge ? 28 : 22),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                option.text,
                style: TextStyle(
                  fontSize: widget.isLarge ? 20 : 16,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
                textAlign: option.emoji != null ? TextAlign.start : TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 1. MULTIPLE CHOICE
// ============================================================

class _MultipleChoiceRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _MultipleChoiceRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_MultipleChoiceRenderer> createState() => _MultipleChoiceRendererState();
}

class _MultipleChoiceRendererState extends State<_MultipleChoiceRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Column(
      children: [
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AnswerOptionButton(
            option: option,
            isSelected: _selectedId == option.id,
            onTap: () {
              setState(() => _selectedId = option.id);
              // Small delay for visual feedback before submitting
              Future.delayed(const Duration(milliseconds: 300), () {
                widget.onAnswer(option.id);
              });
            },
          ),
        )),
      ],
    );
  }
}

// ============================================================
// 2. TRUE / FALSE
// ============================================================

class _TrueFalseRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _TrueFalseRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_TrueFalseRenderer> createState() => _TrueFalseRendererState();
}

class _TrueFalseRendererState extends State<_TrueFalseRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Row(
      children: options.map((option) {
        final isBenar = option.text.toLowerCase().contains('benar');
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedId = option.id);
                Future.delayed(const Duration(milliseconds: 300), () {
                  widget.onAnswer(option.id);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: _selectedId == option.id
                      ? (isBenar ? AppColors.success : AppColors.error).withOpacity(0.1)
                      : AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedId == option.id
                        ? (isBenar ? AppColors.success : AppColors.error)
                        : AppColors.surfaceVariant,
                    width: _selectedId == option.id ? 2.5 : 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      option.emoji ?? (isBenar ? '✅' : '❌'),
                      style: const TextStyle(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option.text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _selectedId == option.id
                            ? (isBenar ? AppColors.success : AppColors.error)
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// 3. MATCH WORD & IMAGE
// ============================================================

class _MatchWordImageRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _MatchWordImageRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_MatchWordImageRenderer> createState() => _MatchWordImageRendererState();
}

class _MatchWordImageRendererState extends State<_MatchWordImageRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        final isSelected = _selectedId == option.id;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedId = option.id);
            Future.delayed(const Duration(milliseconds: 300), () {
              widget.onAnswer(option.id);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 72) / 2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              children: [
                if (option.emoji != null)
                  Text(
                    option.emoji!,
                    style: const TextStyle(fontSize: 40),
                  ),
                const SizedBox(height: 8),
                Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// 4. LISTEN AND CHOOSE
// ============================================================

class _ListenAndChooseRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _ListenAndChooseRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_ListenAndChooseRenderer> createState() => _ListenAndChooseRendererState();
}

class _ListenAndChooseRendererState extends State<_ListenAndChooseRenderer> {
  String? _selectedId;
  bool _isPlaying = false;

  void _playAudio() {
    // Placeholder: In production, use audioplayers package
    setState(() => _isPlaying = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Column(
      children: [
        // Play audio button
        GestureDetector(
          onTap: _playAudio,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: _isPlaying
                ? const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.secondary,
                    size: 36,
                  ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Tekan untuk mendengarkan',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        // Options
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AnswerOptionButton(
            option: option,
            isSelected: _selectedId == option.id,
            onTap: () {
              setState(() => _selectedId = option.id);
              Future.delayed(const Duration(milliseconds: 300), () {
                widget.onAnswer(option.id);
              });
            },
          ),
        )),
      ],
    );
  }
}

// ============================================================
// 5. FILL IN THE BLANK
// ============================================================

class _FillInTheBlankRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;
  final Function(String) onTextAnswer;

  const _FillInTheBlankRenderer({
    required this.question,
    required this.onAnswer,
    required this.onTextAnswer,
  });

  @override
  State<_FillInTheBlankRenderer> createState() => _FillInTheBlankRendererState();
}

class _FillInTheBlankRendererState extends State<_FillInTheBlankRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    // If options are provided, show them as choice chips
    // Otherwise show a text field
    if (options.isNotEmpty) {
      return Column(
        children: [
          ...options.map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AnswerOptionButton(
              option: option,
              isSelected: _selectedId == option.id,
              onTap: () {
                setState(() => _selectedId = option.id);
                Future.delayed(const Duration(milliseconds: 300), () {
                  widget.onAnswer(option.id);
                });
              },
            ),
          )),
        ],
      );
    }

    // Text input fallback
    return _TextInputAnswer(
      onSubmit: (answer) {
        widget.onTextAnswer(answer);
      },
    );
  }
}

class _TextInputAnswer extends StatefulWidget {
  final Function(String) onSubmit;

  const _TextInputAnswer({required this.onSubmit});

  @override
  State<_TextInputAnswer> createState() => _TextInputAnswerState();
}

class _TextInputAnswerState extends State<_TextInputAnswer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: 'Ketik jawabanmu di sini...',
            filled: true,
            fillColor: AppColors.surfaceVariant.withOpacity(0.5),
          ),
          onSubmitted: widget.onSubmit,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => widget.onSubmit(_controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Jawab',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 6. ARRANGE WORDS
// ============================================================

class _ArrangeWordsRenderer extends StatefulWidget {
  final Question question;
  final Function(List<int>) onSequenceAnswer;

  const _ArrangeWordsRenderer({
    required this.question,
    required this.onSequenceAnswer,
  });

  @override
  State<_ArrangeWordsRenderer> createState() => _ArrangeWordsRendererState();
}

class _ArrangeWordsRendererState extends State<_ArrangeWordsRenderer> {
  final List<WordFragment> _selected = [];
  late List<WordFragment> _available;

  @override
  void initState() {
    super.initState();
    _available = List.from(widget.question.fragments ?? []);
    _available.shuffle(); // Randomize order
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selected words area (sentence being built)
        Container(
          minHeight: 56,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selected.isEmpty
                ? [
                    Text(
                      'Sentuh kata di bawah untuk menyusun kalimat',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : _selected.map((fragment) => _WordChip(
                      text: fragment.text,
                      isSelected: true,
                      onTap: () {
                        setState(() {
                          _selected.remove(fragment);
                          _available.add(fragment);
                        });
                      },
                    )).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Available words to pick from
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _available.map((fragment) => _WordChip(
                text: fragment.text,
                isSelected: false,
                onTap: () {
                  setState(() {
                    _available.remove(fragment);
                    _selected.add(fragment);
                  });
                },
              )).toList(),
        ),

        const SizedBox(height: 16),

        // Submit button (only when all words are selected)
        if (_available.isEmpty && _selected.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSequenceAnswer(
                  _selected.map((f) => f.correctPosition).toList(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Cek Jawaban',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _WordChip({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 7. PICK CORRECT IMAGE
// ============================================================

class _PickCorrectImageRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _PickCorrectImageRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_PickCorrectImageRenderer> createState() => _PickCorrectImageRendererState();
}

class _PickCorrectImageRendererState extends State<_PickCorrectImageRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: options.map((option) {
        final isSelected = _selectedId == option.id;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedId = option.id);
            Future.delayed(const Duration(milliseconds: 300), () {
              widget.onAnswer(option.id);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (option.emoji != null)
                  Text(
                    option.emoji!,
                    style: const TextStyle(fontSize: 44),
                  ),
                const SizedBox(height: 8),
                Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// 8. DRAG & DROP (simplified as tap-to-select matching)
// ============================================================

class _DragAndDropRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _DragAndDropRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_DragAndDropRenderer> createState() => _DragAndDropRendererState();
}

class _DragAndDropRendererState extends State<_DragAndDropRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Column(
      children: [
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AnswerOptionButton(
            option: option,
            isSelected: _selectedId == option.id,
            onTap: () {
              setState(() => _selectedId = option.id);
              Future.delayed(const Duration(milliseconds: 300), () {
                widget.onAnswer(option.id);
              });
            },
          ),
        )),
      ],
    );
  }
}

// ============================================================
// 9. ORDER STORY
// ============================================================

class _OrderStoryRenderer extends StatefulWidget {
  final Question question;
  final Function(List<int>) onSequenceAnswer;

  const _OrderStoryRenderer({
    required this.question,
    required this.onSequenceAnswer,
  });

  @override
  State<_OrderStoryRenderer> createState() => _OrderStoryRendererState();
}

class _OrderStoryRendererState extends State<_OrderStoryRenderer> {
  final List<StoryStep> _selected = [];
  late List<StoryStep> _available;

  @override
  void initState() {
    super.initState();
    _available = List.from(widget.question.storySteps ?? []);
    _available.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ordered steps area
        Container(
          minHeight: 56,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.secondary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selected.isEmpty
                ? [
                    Text(
                      'Sentuh kalimat di bawah untuk mengurutkan cerita',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : _selected.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _StoryStepChip(
                      number: index + 1,
                      text: step.text,
                      emoji: step.emoji,
                      onTap: () {
                        setState(() {
                          _selected.removeAt(index);
                          _available.add(step);
                        });
                      },
                    );
                  }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Available steps to pick from
        ..._available.map((step) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _available.remove(step);
                _selected.add(step);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceVariant, width: 1.5),
              ),
              child: Row(
                children: [
                  if (step.emoji != null) ...[
                    Text(step.emoji!, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      step.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.add_circle_outline_rounded, size: 20),
                ],
              ),
            ),
          ),
        )),

        const SizedBox(height: 16),

        // Submit button
        if (_available.isEmpty && _selected.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSequenceAnswer(
                  _selected.map((s) => s.correctPosition).toList(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Cek Urutan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }
}

class _StoryStepChip extends StatelessWidget {
  final int number;
  final String text;
  final String? emoji;
  final VoidCallback onTap;

  const _StoryStepChip({
    required this.number,
    required this.text,
    this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 10. PICK INITIAL LETTER
// ============================================================

class _PickInitialLetterRenderer extends StatefulWidget {
  final Question question;
  final Function(String) onAnswer;

  const _PickInitialLetterRenderer({
    required this.question,
    required this.onAnswer,
  });

  @override
  State<_PickInitialLetterRenderer> createState() => _PickInitialLetterRendererState();
}

class _PickInitialLetterRendererState extends State<_PickInitialLetterRenderer> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        final isSelected = _selectedId == option.id;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedId = option.id);
            Future.delayed(const Duration(milliseconds: 300), () {
              widget.onAnswer(option.id);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                option.text,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
