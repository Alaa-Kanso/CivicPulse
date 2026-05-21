class RequestDeduplicator {
  final Map<String, Future<dynamic>> _pendingRequests = {};

  Future<T> run<T>(String key, Future<T> Function() request) {
    final existing = _pendingRequests[key];

    if (existing != null) {
      return existing as Future<T>;
    }
    final future = _wrap(request, key);

    _pendingRequests[key] = future;

    return future;
  }

  Future<T> _wrap<T>(Future<T> Function() request, String key) async {
    try {
      return await request();
    } finally {
      _pendingRequests.remove(key);
    }
  }
}
