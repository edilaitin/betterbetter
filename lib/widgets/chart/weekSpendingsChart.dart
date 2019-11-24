import 'package:betterbetter/models/transaction.dart';
import 'package:betterbetter/widgets/chart/dayBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekSpendingsChart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  double totalWeekSpendings = 0;

  WeekSpendingsChart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0;
      recentTransactions.forEach((transaction) => {
            if (transaction.date.weekday == weekDay.weekday)
              totalSum += transaction.amount
          });

      totalWeekSpendings += totalSum;
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((dayTransactions) {
              return Flexible(
                fit: FlexFit.tight,
                child: DayBar(
                  amount: dayTransactions["amount"],
                  day: dayTransactions["day"],
                  weekSpendings: totalWeekSpendings,
                ),
              );
            }).toList(),
          )),
    );
  }
}
