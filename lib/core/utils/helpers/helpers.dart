import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  /// format: **'dd.MM.yyyy HH:mm:ss'**
  static String getTimeAndHourFromTimestamp(Timestamp? timestamp) => DateFormat(
    'dd.MM.yyyy HH:mm:ss',
  ).format(timestamp?.toDate() ?? DateTime.now());

  /// format: **'dd.MM.yyyy'**
  static String getDateFromTimestamp(Timestamp? timestamp) =>
      DateFormat('dd.MM.yyyy').format(timestamp?.toDate() ?? DateTime.now());

  /// format: **'HH:mm:ss'**
  static String getTimeFromTimestamp(Timestamp? timestamp) =>
      DateFormat('HH:mm:ss').format(timestamp?.toDate() ?? DateTime.now());

  /// generate id from DateTime yyyyMMddHHmmss: **'20241024135323'**
  /// if inputDateTime is null by default => DateTime.now()
  static int genIdFromDateTime({DateTime? inputDateTime}) {
    final dateTime = inputDateTime ?? DateTime.now();

    String idString =
        '${dateTime.year}'
        '${dateTime.month.toString().padLeft(2, '0')}'
        '${dateTime.day.toString().padLeft(2, '0')}'
        '${dateTime.hour.toString().padLeft(2, '0')}'
        '${dateTime.minute.toString().padLeft(2, '0')}'
        '${dateTime.second.toString().padLeft(2, '0')}';

    return int.tryParse(idString) ?? 0;
  }

  /// **Parameters:**
  /// - [date]: The DateTime to format. Defaults to `DateTime.now()` if null.
  ///
  /// DateTime.now() => **'2025-12-13 14:03:36.455521'**
  /// to => **'2025-12-13_14-03'**
  static String formatDateForFileName({DateTime? date}) {
    return DateFormat('yyyy-MM-dd_HH-mm').format(date ?? DateTime.now());
  }

  /// **Parameters:**
  /// - [date]: The DateTime to format. Defaults to `DateTime.now()` if null.
  ///
  /// DateTime.now() => **'2025-12-13 14:03:36.455521'**
  /// to => **'2025-12-13'**
  static String formatDate({DateTime? date}) {
    return DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
  }

  /// generate id 30-character from **'0-9, a-z, A-Z'**
  /// default length **'30'**
  static String genRandomString({int length = 30}) {
    const characters =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();

    return List.generate(
      length,
      (index) => characters[random.nextInt(characters.length)],
    ).join();
  }

  /// generate int id 6-character from **'0-9'**
  /// default length **'6'**
  static int genIntId({int length = 6}) {
    const digits = '0123456789';
    const nonZeroDigits = '123456789';
    final random = Random();

    final first = nonZeroDigits[random.nextInt(nonZeroDigits.length)];
    final rest = List.generate(
      length - 1,
      (_) => digits[random.nextInt(digits.length)],
    ).join();

    return int.parse('$first$rest');
  }

  static String? getProductIdFromUrl(String? url) {
    if (url == null) return null;

    final uri = Uri.tryParse(url);
    final id = uri?.queryParameters['id'];

    final isValid = RegExp(r'^[a-zA-Z0-9]{8}$');

    if (id != null && isValid.hasMatch(id)) return id;

    return null;
  }

  static String? makeProductUrlWithId(String? id) {
    if (id == null) return null;
    return '${K.lookAppMsgBaseUrl}$id';
  }
}
