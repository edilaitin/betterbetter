import 'package:betterbetter/pages/login.dart';
import 'package:flutter/material.dart';

class LoginPageRoute extends MaterialPageRoute<Null> {
  LoginPageRoute()
      : super(builder: (BuildContext ctx) {
          return LoginPage();
        });
}
