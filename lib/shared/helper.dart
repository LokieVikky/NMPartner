import 'dart:math';

import 'package:intl/intl.dart';

final Helper helper = Helper._private();

class Helper {
  Helper._private();

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  T? getFirstIndexValue<T>(List? param, {String key = 'value'}) {
    if (param == null) {
      return null;
    }
    if (param.isEmpty) {
      return null;
    }
    return param.first[key];
  }

  DateFormat dateFormat = DateFormat('dd/MM/yy');
  DateFormat timeFormat = DateFormat('HH:mm');

  String getRandomString({int length = 20}) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
