/// 录制间隔 单位分钟
enum RecordInterval implements Comparable<RecordInterval> {
  one(value: 1),
  three(value: 3),
  five(value: 5),
  ten(value: 10);

  const RecordInterval({required this.value});

  final int value;

  @override
  int compareTo(RecordInterval other) => value - other.value;

  factory RecordInterval.fromValue(int value)=>RecordInterval.values.firstWhere((r)=>r.value == value);
}
