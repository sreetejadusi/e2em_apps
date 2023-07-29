import 'package:intl/intl.dart';

bool checkSameDay({required String d1, required String d2}) {
  DateTime dateTime1 = DateTime.parse(d1);
  DateTime dateTime2 = DateTime.parse(d2);
  return (dateTime1.day == dateTime2.day &&
      dateTime1.month == dateTime2.month &&
      dateTime1.year == dateTime2.year);
}

String formatDate(DateTime dt) {
  return DateFormat('MMM dd, yyyy hh:mm aa').format(dt).toString();
}

String dateFromString(String dt) {
  return DateFormat('MMM dd, yyyy hh:mm aa')
      .format(DateTime.parse(dt))
      .toString();
}

// String capitalize(String s) {
//   return "${s[0].toUpperCase()}${s.substring(1).toLowerCase()}";
// }

String capitalize(String sentence) {
  String capital = '';
  String text = sentence.replaceAll('  ', ' ');
  for (String element in text.trim().split(' ')) {
    capital +=
        '${element.trim()[0].toUpperCase()}${element.trim().substring(1)} ';
  }
  return capital;
}
