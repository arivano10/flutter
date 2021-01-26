import './adaptiveFlatButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtx;

  NewTransaction(this.addtx){
    print('constructor newtransaction widget');
  }

  @override
  _NewTransactionState createState() { 
    print('createstate newtrasaction');
    return _NewTransactionState();
 }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titlecontroller = TextEditingController();

  final _amountcontroller = TextEditingController();
  _NewTransactionState(){
    print('construtor of newtrans state');
  }
  DateTime picked;
  @override
  void initState() {
    print('initstate()');
    super.initState();
  }
  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didupdate()');
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
     print('dispose');
    super.dispose();
  }
  void _submitData() {
    if (_amountcontroller.text.isEmpty) {
      return;
    }
    final enteredtitle = _titlecontroller.text;
    final enteredamount = double.parse(_amountcontroller.text);

    if (enteredtitle.isEmpty || enteredamount <= 0 || picked == null) {
      return;
    }

    widget.addtx(enteredtitle, enteredamount, picked);
    Navigator.of(context).pop();
  }

  void _pickedDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        picked = selectedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
     
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titlecontroller,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(picked == null
                        ? "no date choosen!!"
                        : DateFormat.yMd().format(picked)),
                    AdaptiveFlatButton('Choose Date',_pickedDate),
                  ],
                ),
              ),
              RaisedButton(
                child: Text(
                  'Add',
                  style:
                      TextStyle(color: Theme.of(context).textTheme.button.color),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
