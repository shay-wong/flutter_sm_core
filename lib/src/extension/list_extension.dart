extension ListExt<E> on List<E> {
  void exchange(int a, int b) {
    final temp = elementAt(a);
    this[a] = this[b];
    this[b] = temp;
  }

  bool containsWhere(bool Function(E element) test) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      E element = this[i];
      if (test(element)) return true;
      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }
    return false;
  }

  void replaceWhere(bool Function(E element) test, E replacements) {
    final index = indexWhere(test);
    if (index != -1) {
      replaceRange(index, index + 1, [replacements]);
    }
  }
}
