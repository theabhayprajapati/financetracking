// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:trackingfinance/google_sheets_api.dart';

import 'homepage.dart';

void main(List<String> args) {
  // ! initailixing the google apis
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
