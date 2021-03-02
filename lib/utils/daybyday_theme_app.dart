import 'package:flutter/material.dart';

class DayByDayAppTheme {
  static const MaterialColor primarySwatchColor = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static const Color accentColor = Color(0xff00B0FF);
  static const Color scaffoldBackGroundColor = primarySwatchColor;
  static const Color floatingActionButtonBackgroudColor = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color headLineColor = Color.fromRGBO(0, 0, 0, 0.7);

  static const String fontFamilyPlayfairDispley = "PlayfairDispley";
  static const String fontFamilyBigShouldersStencilText = "BigShouldersStencilText";

  static final appTheme = ThemeData(
    primarySwatch: primarySwatchColor,
    brightness: Brightness.light,
    fontFamily: "OpenSans",
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: headLineColor,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          fontFamily: "OpenSans",
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primarySwatchColor,
    ),
    scaffoldBackgroundColor: scaffoldBackGroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 5,
      backgroundColor: floatingActionButtonBackgroudColor,
    ),
  );
}
