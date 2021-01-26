import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const availablecolors=
    [Colors.amber,
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.pink,
    Colors.purple];
     _bgColor=availablecolors[Random().nextInt(8)];
   super.initState();

  
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              height: 20,
              child: FittedBox(
                  child: Text(
                      '₹${widget.transaction.amount.toStringAsFixed(1)}')),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
            DateFormat.yMMMMd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
                textColor: Colors.red,
                label: const Text('Delete'),
                icon:const  Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                icon:const  Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
