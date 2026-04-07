// core/extensions/date_time_formatting_extension.dart
extension DateTimeFormattingExtension on DateTime {
  String toAppDateTime() {
    final local = toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day.$month.$year  $hour:$minute';
  }
}
