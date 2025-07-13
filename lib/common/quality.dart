/// 视频质量
enum Quality implements Comparable<Quality> {
  // 480p
  sd(value: "SD"),
  // 720p
  hd(value: "HD"),
  // 1080p
  fhd(value: "FHD"),
  // 2160p
  uhd(value: "UHD");

  const Quality({required this.value});

  final String value;

  @override
  int compareTo(Quality other) => value.length - other.value.length;

  factory Quality.fromValue(String value) =>
      Quality.values.firstWhere((q) => q.value == value);
}
