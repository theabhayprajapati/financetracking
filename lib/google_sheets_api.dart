import 'dart:html';

import 'package:gsheets/gsheets.dart';
import 'package:trackingfinance/auth/secrets.dart';

class GoogleSheetsApi {
  static const _credential = xredential;

  static final _spreadsheetsId = spreadsheetsId;
  final _gsheets = GSheets(_credential);
  static Worksheet? _worksheet;
  // ? some variables to keep track of...
  static int numberOftransaction = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;
// * initaillze spreadsheets
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetsId);
    _worksheet = ss.worksheetByTitle('trackingfinance');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOftransaction + 1)) !=
        '') {
      numberOftransaction++;
    }
    loadtransaction();
  }

  static Future loadtransaction() async {
    if (_worksheet == null) return;
    for (int i = 1; i < numberOftransaction; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);
      if (currentTransactions.length < numberOftransaction) {
        currentTransactions
            .add([transactionName, transactionAmount, transactionType]);
      }
    }
    print(currentTransactions[3][2]);
    loading = false;
  }

  static void insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOftransaction++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // ?  calculate income:---
  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

// ? expense cal...
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
