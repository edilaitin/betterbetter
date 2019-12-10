import 'package:betterbetter/bzl/googleSignIn.dart';
import 'package:betterbetter/routes/login.dart';
import 'package:betterbetter/widgets/chart/weekSpendingsChart.dart';
import 'package:betterbetter/widgets/transaction/addTransaction.dart';
import 'package:betterbetter/widgets/transaction/transactions.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart' as txModel;

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<txModel.Transaction> _transactions = [];
  bool _showChart = false;
  GSignIn gSignIn = GSignIn();

  void _addTransaction(String title, double amount, DateTime date) {
    final newTransaction = txModel.Transaction(
      amount: amount,
      title: title,
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (builderContext) {
          return AddTransaction(_addTransaction);
        });
  }

  List<txModel.Transaction> _recentTransactions(
      List<txModel.Transaction> transactions) {
    return transactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        "User name: " +
            (gSignIn.currentUser != null
                ? gSignIn.currentUser.displayName
                : ''),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text("Sign out"),
          onPressed: () async {
            await gSignIn.handleSignOut();
            Navigator.push(context, LoginPageRoute());
          },
        )
      ],
    );
    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(_transactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Show chart"),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child:
                      WeekSpendingsChart(_recentTransactions(_transactions))),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: WeekSpendingsChart(
                          _recentTransactions(_transactions)))
                  : txListWidget
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
