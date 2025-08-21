extension DurationExtensions on Duration {
  // Duration 转 1天1时1分1秒
  String get toChineseString {
    if (inSeconds == 0) return '0秒';

    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final parts = <String>[];

    if (days > 0) parts.add('$days天');
    if (hours > 0) parts.add('$hours时');
    if (minutes > 0) parts.add('$minutes分');
    if (seconds > 0) parts.add('$seconds秒');

    return parts.join('');
  }
}
