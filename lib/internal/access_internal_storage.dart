import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('Box');

class InternalDatabase {
  Map<String, int> dateTimeToMap({required DateTime dateTime}) {
    return {
      'year': dateTime.year,
      'month': dateTime.month,
      'day': dateTime.day,
      'hour': dateTime.hour,
      'minute': dateTime.minute,
      'second': dateTime.second,
      'millisecond': dateTime.millisecond,
      'microsecond': dateTime.microsecond,
    };
  }

  DateTime mapToDateTime({required Map<dynamic, dynamic> map}) {
    return DateTime(
      map['year'],
      map['month'],
      map['day'],
      map['hour'],
      map['minute'],
      map['second'],
      map['millisecond'],
      map['microsecond'],
    );
  }

// fist time ever opening
  void createInitialData() {
    box.put('themeMode', 'ThemeMode.dark');
    box.put('accessToken', '');
    box.put('refreshToken', '');
    box.put('tokenType', '');
    box.put('refreshTokenExpireDateTime', '');
    box.put('currentPageIndex', 0);
  }

  void putData({
    String accessToken = '',
    String refreshToken = '',
    themeMode, // Type ThemeMode required
    String tokenType = '',
    int currentPageIndex = -1,
  }) {
    if (themeMode is ThemeMode) {
      box.put('themeMode', '$themeMode');
    }
    if (accessToken.length > 0) {

      box.put('accessToken', accessToken);
    }
    if (refreshToken.length > 0) {
      box.put('refreshToken', refreshToken);
    }
    if (tokenType.length > 0) {
      box.put('tokenType', tokenType);
    }
    if (currentPageIndex > -1) {
      box.put('currentPageIndex', currentPageIndex);
    }
  }

  void putRefreshTokenExpireDateTime(
      {required DateTime refreshTokenExpireDateTime}) {
        print('putting data');
    box.put('refreshTokenExpireDateTime',
        jsonEncode(dateTimeToMap(dateTime: refreshTokenExpireDateTime)));
  }

  ThemeMode getThemeMode() {
    return (box.get('themeMode') == 'ThemeMode.light')
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  String getAccessToken() {
    return box.get('accessToken');
  }

  String getRefreshToken() {
    return box.get('refreshToken');
  }

  String getTokenType() {
    return box.get('tokenType');
  }

  int getCurrentPageIndex() {
    return box.get('currentPageIndex');
  }

  DateTime getRefreshTokenExpireDateTime() {
    String refreshTokenExpireDateTime_map_json =
        box.get('refreshTokenExpireDateTime');
    if (refreshTokenExpireDateTime_map_json.length > 0) {
    Map refreshTokenExpireDateTime_map = jsonDecode(refreshTokenExpireDateTime_map_json);
    DateTime refreshTokenExpireDateTime =
        mapToDateTime(map: refreshTokenExpireDateTime_map);
    return refreshTokenExpireDateTime;}
    throw ErrorDescription('No refresh token');
  }

  String exceptionToString({required String error}) {
    return '$error'.replaceAll('ErrorDescription:', '');
  }

  // void _toggleTheme() {
  //   setState(
  //     () {
  //       _currentThemeMode = _currentThemeMode == ThemeMode.light
  //           ? ThemeMode.dark
  //           : ThemeMode.light;
  //       db.putData(themeMode: _currentThemeMode);
  //     },
  //   );
  // }
}
