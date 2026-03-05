class BolaoCache {
  static final BolaoCache _singleton = BolaoCache._internal();
  String get bolaoName => _bolaoName;
  int get bolaoId => _bolaoId;

  int _bolaoId = 0;
  String _bolaoName = "";
  Function(int, String)? _bolaoChangedCallback;

  factory BolaoCache() {
    return _singleton;
  }

  BolaoCache._internal();

  void updateBolao(int id, String newName) {
    _bolaoName = newName;
    _bolaoId = id;
    _bolaoChangedCallback?.call(id, newName);
  }

  void onBolaoChanged(Function(int, String)? callback) {
    _bolaoChangedCallback = callback;
  }
}
