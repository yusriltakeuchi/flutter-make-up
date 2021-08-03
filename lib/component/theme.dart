import 'package:flutter/material.dart';

import 'const.dart';

class CustomTheme {
  static ThemeData theme = ThemeData(
    accentColor: SECONDARY_COLOR,
    primaryColor: PRIMARY_COLOR,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: GREY_COLOR),
      bodyText2: TextStyle(color: GREY_COLOR),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          SECONDARY_COLOR,
        ),
      ),
    ),
  );
}
