class BolaoCache {
  static final BolaoCache _singleton = BolaoCache._internal();
  int bolaoId = 0;

  factory BolaoCache() {
    return _singleton;
  }

  BolaoCache._internal();
}