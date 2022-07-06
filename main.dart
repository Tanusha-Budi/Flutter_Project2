import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import '../models/transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.teal, accentColor: Colors.brown),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final List<Transactions> userTransactions = [
    //Transactions(id: 'ts1', title: 'Jeans', amount: 1500, date: DateTime.now()),
    // Transactions(
    // id: 'ts2', title: 'New mobile', amount: 24897, date: DateTime.now())
  ];

  bool showChart = false;

  List<Transactions> get _recentTransactions {
    return userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txtitle, double txamount, DateTime chosenDate) {
    final newTx = Transactions(
        id: DateTime.now().toString(),
        title: txtitle,
        amount: txamount,
        date: chosenDate);

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return (NewTransaction(_addNewTransaction));
      },
    );
  }

  void deleteTransaction(String id) {
    setState(() {
      return userTransactions.removeWhere((tx) => (tx.id == id));
    });
  }

  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _startNewTransaction(context),
              )
            ]),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: (() => _startNewTransaction(context)),
                  icon: Icon(Icons.add))
            ],
          );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(userTransactions, deleteTransaction));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show Chart",
                    style: TextStyle(fontSize: 25),
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: showChart,
                      onChanged: (val) {
                        setState(() {
                          showChart = val;
                        });
                      })
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txListWidget,
            showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
          ]),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startNewTransaction(context),
                  ),
          );
  }
}
