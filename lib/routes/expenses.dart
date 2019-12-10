import 'package:betterbetter/pages/expenses.dart';
import 'package:flutter/material.dart';

class ExpensesPageRoute extends MaterialPageRoute<Null> {
  ExpensesPageRoute()
      : super(builder: (BuildContext ctx) {
          return ExpensesPage();
        });
}
