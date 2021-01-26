import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/transactionlist.dart';
import './widgets/newTransaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline5: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
              ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  
  final List<Transaction> _usertransaction = [];
  bool _showchart = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  
   void didChangeAppLifecyleState(AppLifecycleState state){
     print(state);
    
   }

   @override
   void dispose(){
     WidgetsBinding.instance.removeObserver(this);
     super.dispose();
   }
  List<Transaction> get _recentTrans {
    return _usertransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txtitle, double txamount, DateTime choosendate) {
    final newtx = Transaction(
      title: txtitle,
      amount: txamount,
      date: choosendate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _usertransaction.add(newtx);
    });
  }

  void _startnewtransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appbar, Widget txlist) {
    return [
      Container(
          child: Chart(_recentTrans),
          height: (mediaQuery.size.height -
                  appbar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3),
      txlist
    ];
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appbar, Widget txlist) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('showchart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showchart,
            onChanged: (val) {
              setState(() {
                _showchart = val;
              });
            },
          )
        ],
      ),
      _showchart
          ? Container(
              child: Chart(_recentTrans),
              height: (mediaQuery.size.height -
                      appbar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7)
          : txlist
    ];
  }
   Widget _buildappbar(){
     return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expense',
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startnewtransaction(context),
              )
            ]),
          )
        : AppBar(
            title: const Text(
              'Personal Expense',
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startnewtransaction(context),
              )
            ],
          );
   }
   
  @override
  Widget build(BuildContext context) {
    print('build() homepage()');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appbar = _buildappbar();
    final txlist = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_usertransaction, _deleteTransaction));
    final pageView = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appbar, txlist),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appbar, txlist)
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageView,
            navigationBar: appbar,
          )
        : Scaffold(
            appBar: appbar,
            body: pageView,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startnewtransaction(context),
                  ),
          );
  }
}
