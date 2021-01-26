import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transactionItem.dart';
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() transactionist()');
    return Container(
        height: 500,
        child: transactions.isEmpty
            ? LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    children: <Widget>[
                      Text(
                        'No transactions are added',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                          height: constraints.maxHeight * 0.6,
                          child: Image.asset(
                            'assets/images/cash.jpg',
                            fit: BoxFit.cover,
                          ))
                    ],
                  );
                },
              )
            : ListView(
                children: transactions
                    .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                        transaction: tx, deleteTx: deleteTx))
                    .toList(),
              ));
  }
}
