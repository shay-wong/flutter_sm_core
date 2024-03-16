extension IterableEx<E extends Enum> on Iterable<E> {
  CombinedEnum combined() {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) {
      throw StateError("No element");
    }
    CombinedEnum value = CombinedEnum() | iterator.current;
    while (iterator.moveNext()) {
      value = value | iterator.current;
    }
    return value;
  }
}

extension EnumEx<T extends Enum> on Enum {
  CombinedEnum operator |(T other) {
    return CombinedEnum(mask: (1 << index) | (1 << other.index), values: {this, other});
  }
}

final class CombinedEnum<T extends Enum> {
  CombinedEnum({
    int mask = 0,
    Set<T>? values,
  })  : _mask = mask,
        _values = values ?? {} {
    if (_mask != 0 && _values.isEmpty) {}
  }

  final Set<T> _values;

  int _mask;

  @override
  String toString() => 'CombinedEnum(mask: $mask, values: $values)';

  int get mask => _mask;
  Set<T> get values => _values;

  bool contains(Object? other) => _values.contains(other);

  CombinedEnum operator |(T other) => this
    .._mask = mask | (1 << other.index)
    .._values.add(other);

  // 包含即使相等
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is CombinedEnum) return values.containsAll(other.values);
    if (other is T) return contains(other);
    return false;
  }

  @override
  int get hashCode => _values.hashCode;
}
