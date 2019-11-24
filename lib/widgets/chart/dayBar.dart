import 'package:flutter/material.dart';

class DayBar extends StatelessWidget {
  final String day;
  final double amount;
  final double weekSpendings;

  const DayBar({this.day, this.amount, this.weekSpendings});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.175,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  day.toString(),
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.025,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.7,
                      ),
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor:
                        weekSpendings == 0 ? 0 : amount / weekSpendings,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.025,
            ),
            Container(
              height: constraints.maxHeight * 0.175,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(amount.toStringAsFixed(0)),
              ),
            )
          ],
        );
      },
    );
  }
}
