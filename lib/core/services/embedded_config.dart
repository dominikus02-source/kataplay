import 'app_mode.dart';

class EmbeddedConfig {
  final bool isEmbedded;
  final String? hostUserId;
  final String? hostToken;
  final String? hostName;
  final String? hostAvatarUrl;

  const EmbeddedConfig({
    this.isEmbedded = false,
    this.hostUserId,
    this.hostToken,
    this.hostName,
    this.hostAvatarUrl,
  });

  bool get hasHostContext => hostUserId != null && hostUserId!.isNotEmpty;

  static EmbeddedConfig fromAppMode(AppModeConfig config) {
    if (!config.isEmbedded) return const EmbeddedConfig();
    return EmbeddedConfig(
      isEmbedded: true,
      hostUserId: config.hostUserId,
      hostToken: config.hostToken,
    );
  }

  Map<String, String> toQueryParams() {
    return {
      if (isEmbedded) 'mode': 'embedded',
      if (hostUserId != null) 'userId': hostUserId!,
      if (hostToken != null) 'token': hostToken!,
    };
  }
}
