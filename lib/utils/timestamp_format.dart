import 'package:intl/intl.dart';

class TimestampFormat {
  /// 将时间戳字符串转成时间
  /// 如果未转换成功，返回原始数据
  /// [value] 需要格式化的时间戳字符串
  /// [format] 格式化字符串
  /// @returns 格式化后的字符串
  static String timestampToTimeString(
    String value, {
    String format = "yyyy-MM-dd HH:mm",
  }) {
    final int? timeStamp = int.tryParse(value);

    if (timeStamp == null) {
      return value;
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);

    return DateFormat(format).format(dateTime);
  }
}
