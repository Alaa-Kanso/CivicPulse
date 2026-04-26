class RequestDeduplicator {
  final Map<String, Future> _pendingRequests = {};

  Future<T> run<T>(String key, Future<T> Function() request) {
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key] as Future<T>;
    }

    final future = request().whenComplete(() {
      _pendingRequests.remove(key);
    });

    _pendingRequests[key] = future;
    return future;
  }
}
