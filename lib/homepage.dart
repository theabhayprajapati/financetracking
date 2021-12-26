import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackingfinance/google_sheets_api.dart';
import 'package:trackingfinance/loading_circle.dart';
import 'package:trackingfinance/plus_sign.dart';
import 'package:trackingfinance/topnewcard.dart';
import 'package:trackingfinance/transaction.dart';
import 'dart:async';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

//  ? enter transaction
  void _enterTransaction() {
    GoogleSheetsApi.insert(
        _textcontrollerITEM.text, _textcontrollerAMOUNT.text, _isIncome);
  }

// ? new transaction
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Income'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  // ?waiting for loading...
  bool timerhasstarted = false;
  void startLoading() {
    timerhasstarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ? start loading until the data arrivees;
    if (GoogleSheetsApi.loading == true && timerhasstarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopnewCard(
              balance: (GoogleSheetsApi.calculateIncome() -
                      GoogleSheetsApi.calculateExpense())
                  .toString(),
              expense: GoogleSheetsApi.calculateExpense().toString(),
              income: GoogleSheetsApi.calculateIncome().toString(),
            ),
            Expanded(
                child: Container(
                    child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  /* 
                  Expanded(
                      child: GoogleSheetsApi.loading == true
                          ? LoadingCircle()
                          :  */
                  RefreshIndicator(
                    onRefresh: GoogleSheetsApi.countRows,
                    child: ListView.builder(
                        itemCount: GoogleSheetsApi.currentTransactions.length,
                        itemBuilder: (context, index) {
                          return MyTransaction(
                            transactionName:
                                GoogleSheetsApi.currentTransactions[index][0],
                            money: GoogleSheetsApi.currentTransactions[index]
                                [1],
                            expenseOrIncome:
                                GoogleSheetsApi.currentTransactions[index][2],
                          );
                        }),
                  )
                ],
              ),
            ))),
            PlusSign(
              function: _newTransaction,
            )
          ],
        ),
      ),
    );
  }
}
