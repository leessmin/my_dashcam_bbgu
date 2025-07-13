/// 可存储的最大空间，单位GB, 0无上限
enum SaveSize implements Comparable<SaveSize> {
  one(value: 1),
  five(value: 5),
  ten(value: 10),
  twenty(value: 20),
  infinite(value: 0);

  const SaveSize({required this.value});

  final int value;

  @override
  int compareTo(SaveSize other) => value - other.value;

  factory SaveSize.fromValue(int value) =>
      SaveSize.values.firstWhere((s) => s.value == value);
}
