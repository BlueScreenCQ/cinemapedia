import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(decimalDigits: decimals, symbol: '', locale: 'es').format(number);

    return formattedNumber;
  }

  static String intNumber(int number) {
    final formattedNumber = NumberFormat.compact(locale: 'es').format(number);

    return formattedNumber;
  }

  static String money(int number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.currency(decimalDigits: decimals, symbol: '\$', locale: 'es').format(number);

    return formattedNumber;
  }

  static String fechaCorta(DateTime date) {
    String formattedDate = '${date.day} ';

    switch (date.month) {
      case 1:
        formattedDate += 'ene';
        break;
      case 2:
        formattedDate += 'feb';
        break;
      case 3:
        formattedDate += 'mar';
        break;
      case 4:
        formattedDate += 'abr';
        break;
      case 5:
        formattedDate += 'may';
        break;
      case 6:
        formattedDate += 'jun';
        break;
      case 7:
        formattedDate += 'jul';
        break;
      case 8:
        formattedDate += 'ago';
        break;
      case 9:
        formattedDate += 'sep';
        break;
      case 10:
        formattedDate += 'oct';
        break;
      case 11:
        formattedDate += 'nov';
        break;
      case 12:
        formattedDate += 'dic';
        break;
    }

    return formattedDate;
  }
}
