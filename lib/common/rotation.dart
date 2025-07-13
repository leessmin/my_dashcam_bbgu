/// 旋转角度
enum Rotation implements Comparable<Rotation> {
  // 旋转0度
  rotation0(value: 0, label: "0°"),
  // 旋转90度
  rotation90(value: 1, label: "90°"),
  // 旋转180度
  rotation180(value: 2, label: "180°"),
  // 旋转270度
  rotation270(value: 3, label: "270°");

  const Rotation({required this.value, required this.label});

  final int value;
  final String label;

  @override
  int compareTo(Rotation other) => value - other.value;

  factory Rotation.fromValue(int value) =>
      Rotation.values.firstWhere((r) => r.value == value);
}
