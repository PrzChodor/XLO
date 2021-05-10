import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String convertTimestampToDate(Timestamp timestamp) {
    DateTime messageDateTime = (timestamp).toDate();
    String formattedDate;

    if (calculateDayDifferenceInDate(messageDateTime) >= 0) {
      formattedDate = DateFormat('HH:mm').format(messageDateTime);
    } else {
      formattedDate = DateFormat('dd.MM kk:mm').format(messageDateTime);
    }
    return formattedDate;
  }

  static int calculateDayDifferenceInDate(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
