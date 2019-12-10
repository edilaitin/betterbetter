import 'package:betterbetter/pages/login.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final Widget page;

  App({this.page});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal expenses',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.amber,
        errorColor: Color(0xffF0002F),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: page,
    );
  }
}
