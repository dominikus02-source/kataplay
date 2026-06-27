import 'package:flutter/material.dart';
import '../domain/lesson_step.dart';
import '../domain/lesson_type.dart';
import '../application/lesson_state.dart';
import 'renderers/word_choice_renderer.dart';
import 'renderers/picture_choice_renderer.dart';
import 'renderers/listen_choose_renderer.dart';
import 'renderers/word_order_renderer.dart';
import 'renderers/missing_word_renderer.dart';
import 'renderers/sentence_choice_renderer.dart';
import 'renderers/match_pair_renderer.dart';
import 'renderers/story_reading_renderer.dart';
import 'renderers/story_comprehension_renderer.dart';
import 'renderers/reading_comprehension_renderer.dart';
import 'renderers/record_voice_renderer.dart';
import 'renderers/speaking_practice_renderer.dart';
import 'renderers/true_false_renderer.dart';
import 'renderers/fill_blank_renderer.dart';

class LessonRendererFactory {
  static Widget build({
    required LessonStep step,
    required LessonState state,
    required Function(String) onSelect,
    required VoidCallback onContinue,
    required VoidCallback onRecord,
  }) {
    switch (step.type) {
      case LessonType.wordChoice:
        return WordChoiceRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.pictureChoice:
        return PictureChoiceRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.listenChoose:
        return ListenChooseRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.wordOrder:
        return WordOrderRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.missingWord:
        return MissingWordRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.sentenceChoice:
        return SentenceChoiceRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.matchPair:
        return MatchPairRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.storyReading:
        return StoryReadingRenderer(step: step, state: state, onContinue: onContinue);
      case LessonType.storyComprehension:
        return StoryComprehensionRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.readingComprehension:
        return ReadingComprehensionRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.recordVoice:
        return RecordVoiceRenderer(step: step, state: state, onRecord: onRecord);
      case LessonType.speakingPractice:
        return SpeakingPracticeRenderer(step: step, state: state, onRecord: onRecord);
      case LessonType.trueFalse:
        return TrueFalseRenderer(step: step, state: state, onSelect: onSelect);
      case LessonType.fillBlank:
        return FillBlankRenderer(step: step, state: state, onSelect: onSelect);
    }
  }
}
