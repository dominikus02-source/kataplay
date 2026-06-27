import 'app_mode.dart';

class BahasaCerdasBridge {
  static const String hostName = 'bahasacerdas.com';
  static const String gamePath = '/gim/kataplay';

  BahasaCerdasBridge._();

  static bool isFromBahasaCerdas(AppModeConfig config) {
    return config.source == 'bahasacerdas' || config.isEmbedded;
  }

  static String buildEmbeddedUrl({
    String host = 'https://bahasacerdas.com',
    String? userId,
    String? token,
  }) {
    final params = <String, String>{
      'mode': 'embedded',
      'source': 'bahasacerdas',
    };
    if (userId != null) params['userId'] = userId;
    if (token != null) params['token'] = token;
    final queryString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    return '$host$gamePath?$queryString';
  }
}
