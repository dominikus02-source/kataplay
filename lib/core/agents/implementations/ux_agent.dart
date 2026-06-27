import '../agent.dart';
import '../types.dart';

class UXAgent extends KataPlayAgent<UXSpec, Map<String, dynamic>> {
  @override
  String get name => 'ux';

  @override
  Future<Map<String, dynamic>> process(UXSpec input) async {
    return _decideUX(input);
  }

  Map<String, dynamic> _decideUX(UXSpec input) {
    final mode = _determineMode(input);
    final density = _determineDensity(input);
    final componentSet = _componentSet(mode);

    return {
      'uiMode': mode.name,
      'density': density,
      'components': componentSet,
      'showProgressIndicators': input.errorsInLastMinute < 3,
      'autoPlayAudio': input.isNewUser,
      'useSimplifiedLayout': mode == UIMode.simplified,
      'fontScale': mode == UIMode.simplified ? 1.3 : 1.0,
      'buttonSize': mode == UIMode.simplified ? 'large' : 'normal',
      'animationsEnabled': mode != UIMode.simplified,
    };
  }

  UIMode _determineMode(UXSpec input) {
    if (input.isNewUser) return UIMode.simplified;
    if (input.errorsInLastMinute >= 3) return UIMode.simplified;
    if (input.sessionDurationMinutes > 15 && input.errorsInLastMinute <= 1) {
      return UIMode.enhanced;
    }
    return UIMode.standard;
  }

  String _determineDensity(UXSpec input) {
    if (input.isNewUser) return 'spacious';
    if (input.errorsInLastMinute > 2) return 'spacious';
    if (input.sessionDurationMinutes > 20) return 'compact';
    return 'normal';
  }

  List<String> _componentSet(UIMode mode) {
    switch (mode) {
      case UIMode.simplified:
        return ['character', 'question', 'answer_buttons', 'hint_button'];
      case UIMode.standard:
        return ['character', 'question', 'answer_buttons', 'hint_button', 'progress_bar', 'timer'];
      case UIMode.enhanced:
        return [
          'character', 'question', 'answer_buttons', 'hint_button',
          'progress_bar', 'timer', 'streak_indicator', 'xp_counter',
          'achievement_popup',
        ];
    }
  }
}
