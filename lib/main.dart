import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/services/page_change_service.dart';

import 'package:doctor_mfc_admin/src/index.dart';
import 'package:doctor_mfc_admin/src/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PageChangeService>(create: (_) => PageChangeService()),
      ],
      child: MaterialApp(
        title: 'Doctor MFC - ADMIN',
        theme: theme(),
        home: Material(
          child: LoginPage(),
        ),
        routes: {
          'home': (context) => IndexPage(),
        },
        builder: (context, child) => Material(child: child),
      ),
    );
  }

  ThemeData theme() {
    return ThemeData(
      accentColor: kAccentColor,
      primaryColor: kPrimaryColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: kSecondaryLightColor,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: kAccentColor,
          shadowColor: kAccentColor,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 1.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
        ),
      ),
      brightness: Brightness.light,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w600, color: kFontBlack),
        headline2: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        headline3: TextStyle(
          color: kFontWhite.withOpacity(0.55),
          fontSize: 15,
        ),
        headline4: const TextStyle(
          color: kFontWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        headline5: const TextStyle(
          color: kFontWhite,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        headline6: TextStyle(
          color: kFontWhite.withOpacity(0.55),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        bodyText1: const TextStyle(
          color: kFontWhite,
          fontWeight: FontWeight.bold,
        ),
        button: TextStyle(
          color: kFontWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: BorderSide(width: 1.5, color: kPrimaryColor),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData().copyWith(
        cursorColor: kPrimaryColor,
      ),
    );
  }
}
