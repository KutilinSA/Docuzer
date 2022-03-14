class AsyncStateManager {
  final List<String> _requests = [];
  bool get isRequesting => _requests.isNotEmpty;

  void addRequest(String request) => _requests.add(request);
  void removeRequest(String request) => _requests.remove(request);
  bool hasRequest(String request) => _requests.contains(request);
  void clear() => _requests.clear();
}