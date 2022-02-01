import 'package:flutter/services.dart';

import '../utils/allUtils.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData get(String key) {
    return themes[key];
  }

  static void setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: themes['dark'].primaryColor, // Color for Android
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness:
            Brightness.light, // Dark == white status bar -- for IOS.

        systemStatusBarContrastEnforced: false));
  }

  Color primaryColor = Color(0xFFED1C24);
  Color primaryColorDark = Color(0x99ED1C24);
  Color backgroundColor = Colors.white;
  Color canvasColor = Colors.white;
  Color textbodyText1 = Color(0xff343434);
  Color bottomAppbarColor = Color(0xffeef1f5);
  Color headline2 = Color(0x80343434);
}

Map<String, ThemeData> themes = {'dark': _buildDarkTheme()};

TextTheme _buildTextTheme(
  TextTheme base, {
  Color bodyText1,
  Color headline2,
}) {
  return base.copyWith(
    headline1: base.headline1.copyWith(
      color: Colors.white,
      fontFamily: "Din",
    ),
    bodyText1: base.headline1.copyWith(
      color: bodyText1 != null ? bodyText1 : new Color(0xff343434),
      fontSize: 14.0,
      fontFamily: "Din",
    ),
    // headline1: base.headline1.copyWith(
    //   color: Colors.white,
    //   fontFamily: "Din",
    // ),
    bodyText2: base.headline1.copyWith(
      color: Colors.white,
      fontFamily: "Din",
    ),
    button: base.headline1.copyWith(
      color: Colors.white,
      fontFamily: "Din",
    ),
    caption: base.headline1.copyWith(
      color: Colors.white,
      fontFamily: "Din",
    ),
    headline2: base.headline1.copyWith(
      color: headline2 != null ? headline2 : new Color(0x80343434),
      fontFamily: "Din",
    ),
    headline3: base.headline1.copyWith(
      color: new Color(0xff38576E),
      fontFamily: "Din",
    ),
    headline4: base.headline1.copyWith(
      color: new Color(0xffb4b4b4),
      fontFamily: "Din",
    ),
  );
  // to be seen
}

ThemeData _buildDarkTheme() {
  Color primaryColor = Color(0xFFED1C24);
  Color primaryColorDark = Color(0x99ED1C24);
  Color backgroundColor = Colors.white;
  Color canvasColor = Colors.white;
  Color textbodyText1 = Colors.black;
  Color bottomAppbarColor = Color(0xffeef1f5);
  Color headline2 = Color(0x80343434);
  final ThemeData theme = ThemeData(
    fontFamily: "Din",
  );

  return theme.copyWith(
    brightness: Brightness.light,
    disabledColor: new Color(0x80343434),
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    bottomAppBarColor: bottomAppbarColor,
    indicatorColor: Colors.white,
    primaryColorLight: Colors.white,
    colorScheme: theme.colorScheme.copyWith(secondary: primaryColor),
    canvasColor: canvasColor,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: backgroundColor,
    errorColor: const Color(0xFFB00020),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    // colorScheme: ColorScheme.dark(
    //   primary: primaryColor,
    //   brightness: Brightness.dark,
    //   background: bottomAppbarColor,
    //   onBackground: bottomAppbarColor,
    //   onPrimary: primaryColor,
    //   primaryVariant: primaryColor,

    // ),
    textSelectionTheme:
        theme.textSelectionTheme.copyWith(selectionHandleColor: Colors.white),

    unselectedWidgetColor: primaryColor,
    textTheme: _buildTextTheme(ThemeData.light().textTheme,
            bodyText1: textbodyText1, headline2: headline2)
        .apply(
      bodyColor: textbodyText1,
      // displayColor: Colors.black,
    ),

    primaryTextTheme: _buildTextTheme(ThemeData.light().primaryTextTheme,
        bodyText1: textbodyText1, headline2: headline2),
  );
}
