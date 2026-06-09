import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/question_model.dart';

/// Main question renderer that delegates to type-specific sub-renderers
/// Supports all 10 question types with Duolingo dark theme style
class QuestionRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;
  final Function(String) onTextAnswer;
  final Function(List<int>) onSequenceAnswer;

  const QuestionRenderer({
    super.key,
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
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
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onAnswer: onAnswer,
          );

        case QuestionType.trueFalse:
          return _TrueFalseRenderer(
            question: question,
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onAnswer: onAnswer,
          );

        case QuestionType.matchWordImage:
          return _MatchWordImageRenderer(
            question: question,
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onAnswer: onAnswer,
          );

        case QuestionType.listenAndChoose:
          return _ListenAndChooseRenderer(
            question: question,
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onAnswer: onAnswer,
          );

        case QuestionType.fillInTheBlank:
          return _FillInTheBlankRenderer(
            question: question,
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
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
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onAnswer: onAnswer,
          );

        case QuestionType.dragAndDrop:
          return _DragAndDropRenderer(
            question: question,
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
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
            selectedAnswerId: selectedAnswerId,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onAnswer: onAnswer,
          );
      }
    } catch (e) {
      // Safe fallback — never crash on render
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.learningWrong.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Soal ini belum tersedia. Lewati ke soal berikutnya.',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(fontSize: 14, color: Colors.white54),
        ),
      );
    }
  }
}

// ============================================================
// SHARED: Dark Answer Option Tile (Duolingo-style)
// ============================================================

class _DarkAnswerTile extends StatefulWidget {
  final AnswerOption option;
  final bool isSelected;
  final bool isAnswered;
  final bool? isCorrect;
  final VoidCallback onTap;
  final bool isLarge;

  const _DarkAnswerTile({
    required this.option,
    this.isSelected = false,
    this.isAnswered = false,
    this.isCorrect,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  State<_DarkAnswerTile> createState() => _DarkAnswerTileState();
}

class _DarkAnswerTileState extends State<_DarkAnswerTile> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  /// Get the border color based on state
  Color get _borderColor {
    if (widget.isAnswered) {
      if (widget.option.isCorrect) return AppColors.learningCorrect;
      if (widget.isSelected && !widget.option.isCorrect) return AppColors.learningWrong;
      return AppColors.learningBorder;
    }
    if (widget.isSelected) return AppColors.learningTileSelected;
    return AppColors.learningBorder;
  }

  double get _borderWidth {
    if (widget.isAnswered && (widget.option.isCorrect || widget.isSelected)) return 2.5;
    if (widget.isSelected) return 2.5;
    return 1.5;
  }

  Color get _bgColor {
    if (widget.isAnswered) {
      if (widget.option.isCorrect) return AppColors.learningCorrect.withOpacity(0.15);
      if (widget.isSelected) return AppColors.learningWrong.withOpacity(0.15);
      return AppColors.learningTileBg;
    }
    if (widget.isSelected) return AppColors.learningTileSelected.withOpacity(0.1);
    return AppColors.learningTileBg;
  }

  Color get _textColor {
    if (widget.isAnswered) {
      if (widget.option.isCorrect) return AppColors.learningCorrect;
      if (widget.isSelected) return AppColors.learningWrong;
      return AppColors.learningTextSecondary;
    }
    if (widget.isSelected) return AppColors.learningTileSelected;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final option = widget.option;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isAnswered ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_scale),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isLarge ? 24 : 16,
          vertical: widget.isLarge ? 18 : 14,
        ),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
          border: Border.all(
            color: _borderColor,
            width: _borderWidth,
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
                style: GoogleFonts.nunito(
                  fontSize: widget.isLarge ? 20 : 16,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
                textAlign: option.emoji != null ? TextAlign.start : TextAlign.center,
              ),
            ),
            // Show check/x icon after answer
            if (widget.isAnswered) ...[
              const SizedBox(width: 8),
              Icon(
                widget.option.isCorrect
                    ? Icons.check_circle_rounded
                    : (widget.isSelected ? Icons.cancel_rounded : null),
                color: widget.option.isCorrect
                    ? AppColors.learningCorrect
                    : AppColors.learningWrong,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 1. MULTIPLE CHOICE
// ============================================================

class _MultipleChoiceRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _MultipleChoiceRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return Column(
      children: [
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _DarkAnswerTile(
            option: option,
            isSelected: selectedAnswerId == option.id,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onTap: () => onAnswer(option.id),
          ),
        )),
      ],
    );
  }
}

// ============================================================
// 2. TRUE / FALSE
// ============================================================

class _TrueFalseRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _TrueFalseRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return Row(
      children: options.map((option) {
        final isBenar = option.text.toLowerCase().contains('benar');
        final isSelected = selectedAnswerId == option.id;

        Color borderColor;
        double borderWidth;
        Color bgColor;
        Color textColor;

        if (isAnswered) {
          if (option.isCorrect) {
            borderColor = AppColors.learningCorrect;
            bgColor = AppColors.learningCorrect.withOpacity(0.15);
            textColor = AppColors.learningCorrect;
            borderWidth = 2.5;
          } else if (isSelected) {
            borderColor = AppColors.learningWrong;
            bgColor = AppColors.learningWrong.withOpacity(0.15);
            textColor = AppColors.learningWrong;
            borderWidth = 2.5;
          } else {
            borderColor = AppColors.learningBorder;
            bgColor = AppColors.learningTileBg;
            textColor = AppColors.learningTextSecondary;
            borderWidth = 1.5;
          }
        } else {
          borderColor = isSelected ? AppColors.learningTileSelected : AppColors.learningBorder;
          bgColor = isSelected ? AppColors.learningTileSelected.withOpacity(0.1) : AppColors.learningTileBg;
          textColor = isSelected ? AppColors.learningTileSelected : Colors.white;
          borderWidth = isSelected ? 2.5 : 1.5;
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: isAnswered ? null : () => onAnswer(option.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: borderWidth),
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
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
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
// 3. MATCH WORD & IMAGE — Dark grid style
// ============================================================

class _MatchWordImageRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _MatchWordImageRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        final isSelected = selectedAnswerId == option.id;

        Color borderColor;
        Color bgColor;
        Color textColor;

        if (isAnswered) {
          if (option.isCorrect) {
            borderColor = AppColors.learningCorrect;
            bgColor = AppColors.learningCorrect.withOpacity(0.15);
            textColor = AppColors.learningCorrect;
          } else if (isSelected) {
            borderColor = AppColors.learningWrong;
            bgColor = AppColors.learningWrong.withOpacity(0.15);
            textColor = AppColors.learningWrong;
          } else {
            borderColor = AppColors.learningBorder;
            bgColor = AppColors.learningTileBg;
            textColor = AppColors.learningTextSecondary;
          }
        } else {
          borderColor = isSelected ? AppColors.learningTileSelected : AppColors.learningBorder;
          bgColor = isSelected ? AppColors.learningTileSelected.withOpacity(0.1) : AppColors.learningTileBg;
          textColor = isSelected ? AppColors.learningTileSelected : Colors.white;
        }

        return GestureDetector(
          onTap: isAnswered ? null : () => onAnswer(option.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 72) / 2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && option.isCorrect) ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              children: [
                if (option.emoji != null)
                  Text(option.emoji!, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(
                  option.text,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
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
// 4. LISTEN AND CHOOSE — Dark theme audio buttons
// ============================================================

class _ListenAndChooseRenderer extends StatefulWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _ListenAndChooseRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  State<_ListenAndChooseRenderer> createState() => _ListenAndChooseRendererState();
}

class _ListenAndChooseRendererState extends State<_ListenAndChooseRenderer> {
  bool _isPlaying = false;

  void _playAudio() {
    // Placeholder: In production, use audioplayers package
    setState(() => _isPlaying = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _playSlowAudio() {
    // Placeholder for slow audio playback
    setState(() => _isPlaying = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options;

    return Column(
      children: [
        // Audio playback buttons — Duolingo style (two buttons side by side)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Normal speed
            GestureDetector(
              onTap: _isPlaying ? null : _playAudio,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.learningSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.learningBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isPlaying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.cyanAccent,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Icon(Icons.volume_up_rounded, color: Colors.cyanAccent, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Putar',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Slow speed
            GestureDetector(
              onTap: _isPlaying ? null : _playSlowAudio,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.learningSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.learningBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.slow_motion_video_rounded, color: Colors.cyanAccent, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      'Lambat',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.learningTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Options
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _DarkAnswerTile(
            option: option,
            isSelected: widget.selectedAnswerId == option.id,
            isAnswered: widget.isAnswered,
            isCorrect: widget.isCorrect,
            onTap: () => widget.onAnswer(option.id),
          ),
        )),
      ],
    );
  }
}

// ============================================================
// 5. FILL IN THE BLANK
// ============================================================

class _FillInTheBlankRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;
  final Function(String) onTextAnswer;

  const _FillInTheBlankRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
    required this.onTextAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    // If options are provided, show them as choice chips
    if (options.isNotEmpty) {
      return Column(
        children: [
          ...options.map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DarkAnswerTile(
              option: option,
              isSelected: selectedAnswerId == option.id,
              isAnswered: isAnswered,
              isCorrect: isCorrect,
              onTap: () => onAnswer(option.id),
            ),
          )),
        ],
      );
    }

    // Text input fallback — dark theme
    return _DarkTextInputAnswer(
      onSubmit: (answer) {
        onTextAnswer(answer);
      },
    );
  }
}

class _DarkTextInputAnswer extends StatefulWidget {
  final Function(String) onSubmit;

  const _DarkTextInputAnswer({required this.onSubmit});

  @override
  State<_DarkTextInputAnswer> createState() => _DarkTextInputAnswerState();
}

class _DarkTextInputAnswerState extends State<_DarkTextInputAnswer> {
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
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Ketik jawabanmu di sini...',
            hintStyle: GoogleFonts.nunito(color: AppColors.learningTextSecondary),
            filled: true,
            fillColor: AppColors.learningTileBg,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.learningBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.learningTileSelected, width: 2.5),
            ),
          ),
          onSubmitted: widget.onSubmit,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => widget.onSubmit(_controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.learningCheckBtn,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'JAWAB',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 6. ARRANGE WORDS — Dark word tiles
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
    _available.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selected words area (sentence being built) — dark theme
        Container(
          minHeight: 56,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.learningTileSelected.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.learningTileSelected.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selected.isEmpty
                ? [
                    Text(
                      'Sentuh kata di bawah untuk menyusun kalimat',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.learningTextSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : _selected.map((fragment) => _DarkWordChip(
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

        // Available words to pick from — dark tiles
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _available.map((fragment) => _DarkWordChip(
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

        // Submit button
        if (_available.isEmpty && _selected.isNotEmpty)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                widget.onSequenceAnswer(
                  _selected.map((f) => f.correctPosition).toList(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.learningCheckBtn,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'CEK JAWABAN',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DarkWordChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _DarkWordChip({
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
              ? AppColors.learningTileSelected
              : AppColors.learningTileBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.learningTileSelected : AppColors.learningBorder,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.white,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 7. PICK CORRECT IMAGE — Dark grid
// ============================================================

class _PickCorrectImageRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _PickCorrectImageRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: options.map((option) {
        final isSelected = selectedAnswerId == option.id;

        Color borderColor;
        Color bgColor;
        Color textColor;

        if (isAnswered) {
          if (option.isCorrect) {
            borderColor = AppColors.learningCorrect;
            bgColor = AppColors.learningCorrect.withOpacity(0.15);
            textColor = AppColors.learningCorrect;
          } else if (isSelected) {
            borderColor = AppColors.learningWrong;
            bgColor = AppColors.learningWrong.withOpacity(0.15);
            textColor = AppColors.learningWrong;
          } else {
            borderColor = AppColors.learningBorder;
            bgColor = AppColors.learningTileBg;
            textColor = AppColors.learningTextSecondary;
          }
        } else {
          borderColor = isSelected ? AppColors.learningTileSelected : AppColors.learningBorder;
          bgColor = isSelected ? AppColors.learningTileSelected.withOpacity(0.1) : AppColors.learningTileBg;
          textColor = isSelected ? AppColors.learningTileSelected : Colors.white;
        }

        return GestureDetector(
          onTap: isAnswered ? null : () => onAnswer(option.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && option.isCorrect) ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (option.emoji != null)
                  Text(option.emoji!, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 8),
                Text(
                  option.text,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
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

class _DragAndDropRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _DragAndDropRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return Column(
      children: [
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _DarkAnswerTile(
            option: option,
            isSelected: selectedAnswerId == option.id,
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            onTap: () => onAnswer(option.id),
          ),
        )),
      ],
    );
  }
}

// ============================================================
// 9. ORDER STORY — Dark theme
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
            color: AppColors.learningTileSelected.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.learningTileSelected.withOpacity(0.3),
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
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.learningTextSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : _selected.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _DarkStoryStepChip(
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
                color: AppColors.learningTileBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.learningBorder, width: 1.5),
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
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 20,
                    color: AppColors.learningTileSelected,
                  ),
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
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                widget.onSequenceAnswer(
                  _selected.map((s) => s.correctPosition).toList(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.learningCheckBtn,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'CEK URUTAN',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DarkStoryStepChip extends StatelessWidget {
  final int number;
  final String text;
  final String? emoji;
  final VoidCallback onTap;

  const _DarkStoryStepChip({
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
          color: AppColors.learningTileSelected,
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
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.learningTileSelected,
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
                style: GoogleFonts.nunito(
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
// 10. PICK INITIAL LETTER — Dark circle buttons
// ============================================================

class _PickInitialLetterRenderer extends StatelessWidget {
  final Question question;
  final String? selectedAnswerId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(String) onAnswer;

  const _PickInitialLetterRenderer({
    required this.question,
    this.selectedAnswerId,
    this.isAnswered = false,
    this.isCorrect,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        final isSelected = selectedAnswerId == option.id;

        Color borderColor;
        Color bgColor;
        Color textColor;

        if (isAnswered) {
          if (option.isCorrect) {
            borderColor = AppColors.learningCorrect;
            bgColor = AppColors.learningCorrect.withOpacity(0.2);
            textColor = AppColors.learningCorrect;
          } else if (isSelected) {
            borderColor = AppColors.learningWrong;
            bgColor = AppColors.learningWrong.withOpacity(0.2);
            textColor = AppColors.learningWrong;
          } else {
            borderColor = AppColors.learningBorder;
            bgColor = AppColors.learningTileBg;
            textColor = AppColors.learningTextSecondary;
          }
        } else {
          borderColor = isSelected ? AppColors.learningTileSelected : AppColors.learningBorder;
          bgColor = isSelected ? AppColors.learningTileSelected.withOpacity(0.15) : AppColors.learningTileBg;
          textColor = isSelected ? AppColors.learningTileSelected : Colors.white;
        }

        return GestureDetector(
          onTap: isAnswered ? null : () => onAnswer(option.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && option.isCorrect) ? 2.5 : 1.5,
              ),
            ),
            child: Center(
              child: Text(
                option.text,
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
