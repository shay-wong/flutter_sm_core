extension MapEx<K, V> on Map<K, V> {
  /// 将后一个 Map 的内容合并到前一个 Map 中
  void merge(Map<K, V>? other) {
    if (other == null) {
      return;
    }
    addAll(other);
  }

  /// 将后一个 Map 的内容合并到前一个 Map 中
  Map<K, V> mergeTo(Map<K, V>? other) {
    return {...this, ...?other};
  }

  /// 将后一个 Map 的内容合并到前一个 Map 中, 同时过滤掉 `null`
  void mergeNonNull(Map<K, V>? other) {
    merge(
      other
        ?..removeWhere(
          (key, value) => value == null,
        ),
    );
  }

  /// 将后一个 Map 的内容合并到前一个 Map 中, 如果 `key` 不存在, 则插入
  void mergeIfAbsent(Map<K, V>? other) {
    if (other == null) {
      return;
    }
    other.forEach(
      (key, value) {
        putIfAbsent(key, () => value);
      },
    );
  }
}
