enum AppMode { standalone, embedded }

class AppModeConfig {
  final AppMode mode;
  final String? source;
  final String? hostUserId;
  final String? hostToken;

  const AppModeConfig({
    this.mode = AppMode.standalone,
    this.source,
    this.hostUserId,
    this.hostToken,
  });

  bool get isStandalone => mode == AppMode.standalone;
  bool get isEmbedded => mode == AppMode.embedded;
  bool get hasHostUser => hostUserId != null && hostUserId!.isNotEmpty;

  AppModeConfig copyWith({
    AppMode? mode,
    String? source,
    String? hostUserId,
    String? hostToken,
  }) {
    return AppModeConfig(
      mode: mode ?? this.mode,
      source: source ?? this.source,
      hostUserId: hostUserId ?? this.hostUserId,
      hostToken: hostToken ?? this.hostToken,
    );
  }

  static AppModeConfig fromQueryParams(Map<String, String> params) {
    final modeStr = params['mode']?.toLowerCase();
    final mode = modeStr == 'embedded' ? AppMode.embedded : AppMode.standalone;
    return AppModeConfig(
      mode: mode,
      source: params['source'],
      hostUserId: params['userId'],
      hostToken: params['token'],
    );
  }
}
