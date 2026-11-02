import 'package:intl/intl.dart';

class AppHelpers {
  AppHelpers._();

  static String formatDate(DateTime dt) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  static String formatShortDate(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static String formatConfidence(double val) {
    return '${(val * 100).clamp(0, 100).toStringAsFixed(1)}%';
  }
}
