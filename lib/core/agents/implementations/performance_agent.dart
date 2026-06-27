import '../agent.dart';
import '../types.dart';

class PerformanceAgent extends KataPlayAgent<AgentContext, Map<String, dynamic>> {
  @override
  String get name => 'performance';

  @override
  Future<Map<String, dynamic>> process(AgentContext input) async {
    return _optimize(input);
  }

  Map<String, dynamic> _optimize(AgentContext input) {
    final batteryLevel = input.getInt('batteryLevel', defaultValue: 100);
    final networkType = input.getString('networkType', defaultValue: 'wifi');
    final memoryUsage = input.getInt('memoryUsage', defaultValue: 50);

    return {
      'useLocalFallback': _useLocalFallback(networkType, batteryLevel),
      'cacheStrategy': _cacheStrategy(memoryUsage),
      'batchSize': _batchSize(networkType),
      'preloadNextLesson': memoryUsage < 70 && batteryLevel > 20,
      'reduceAnimations': batteryLevel < 20,
      'compressAssets': networkType == 'cellular' && batteryLevel < 30,
      'logLevel': networkType == 'wifi' ? 'verbose' : 'error',
      'syncIntervalMs': _syncInterval(networkType, batteryLevel),
    };
  }

  bool _useLocalFallback(String network, int battery) {
    return network == 'none' || (network == 'cellular' && battery < 15);
  }

  String _cacheStrategy(int memory) {
    if (memory > 80) return 'evict_all';
    if (memory > 60) return 'keep_current';
    return 'prefetch_next';
  }

  int _batchSize(String network) {
    switch (network) {
      case 'wifi':
        return 10;
      case 'cellular':
        return 5;
      default:
        return 3;
    }
  }

  int _syncInterval(String network, int battery) {
    if (network == 'wifi') return 30000;
    if (battery < 20) return 120000;
    return 60000;
  }
}
