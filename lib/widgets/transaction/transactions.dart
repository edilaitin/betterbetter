import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import './transactionCard.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "No transactions added yet!",
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 200,
                child: Image.asset('assets/images/waiting.png'),
              ),
            ],
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionCard(
                name: transactions[index].title,
                amount: transactions[index].amount,
                date: transactions[index].date,
              );
            },
            itemCount: transactions.length,
          );
  }
}
