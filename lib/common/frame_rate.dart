/// 帧率
enum FrameRate implements Comparable<FrameRate> {
  // fps 24
  fps24(value: 24),
  // fps 30
  fps30(value: 30),
  // fps 60
  fps60(value: 60);

  const FrameRate({required this.value});

  final int value;

  @override
  int compareTo(FrameRate other) => value - other.value;

  factory FrameRate.fromValue(int value) =>
      FrameRate.values.firstWhere((f) => f.value == value);
}
