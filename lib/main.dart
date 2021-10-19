import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/services/page_change_service.dart';
import 'package:doctor_mfc_admin/services/test_systems_service.dart';

import 'package:doctor_mfc_admin/src/index_page.dart';
import 'package:doctor_mfc_admin/src/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PageChangeService>(create: (_) => PageChangeService()),
        Provider<TestSystemsService>(create: (_) => TestSystemsService()),
      ],
      child: MaterialApp(
        title: 'Doctor MFC - ADMIN',
        theme: theme(),
        home: LoginPage(),
        routes: {
          'home': (context) => IndexPage(),
        },
        builder: (context, child) => Material(child: child),
      ),
    );
  }

  ThemeData theme() {
    return ThemeData(
      visualDensity: VisualDensity.compact,
      accentColor: kAccentColor,
      focusColor: kPrimaryColor,
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
          // shadowColor: kAccentColor,
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
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        headline4: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          color: Colors.grey[600],
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: const TextStyle(
          color: kFontWhite,
          fontWeight: FontWeight.bold,
        ),
        button: TextStyle(
          color: kFontWhite,
          fontWeight: FontWeight.bold,
        ),
        overline: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
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
