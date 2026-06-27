enum AgentSource { local, remote, cached }

class AgentDecision {
  final String agentName;
  final AgentSource source;
  final Map<String, dynamic> result;
  final Duration latency;

  const AgentDecision({
    required this.agentName,
    required this.source,
    required this.result,
    this.latency = Duration.zero,
  });
}

class AgentGateway {
  final bool remoteEnabled;

  AgentGateway({this.remoteEnabled = false});

  bool get isRemoteEnabled => remoteEnabled;

  Future<AgentDecision> route({
    required String agent,
    required Map<String, dynamic> input,
    required Future<Map<String, dynamic>> Function() localFn,
    Future<Map<String, dynamic>> Function()? remoteFn,
  }) async {
    final stopwatch = Stopwatch()..start();

    if (remoteEnabled && remoteFn != null) {
      try {
        final result = await remoteFn();
        stopwatch.stop();
        return AgentDecision(
          agentName: agent,
          source: AgentSource.remote,
          result: result,
          latency: stopwatch.elapsed,
        );
      } catch (e) {
        // Remote failed, fallback to local
      }
    }

    final result = await localFn();
    stopwatch.stop();
    return AgentDecision(
      agentName: agent,
      source: AgentSource.local,
      result: result,
      latency: stopwatch.elapsed,
    );
  }
}
