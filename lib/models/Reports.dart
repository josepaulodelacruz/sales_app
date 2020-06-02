import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sari_sales/models/Transactions.dart';

class Reports {
  String title;
  Widget card;
  double amount;

  Reports({String cardTitle, Widget isCard}) {
    title = cardTitle;
    card = isCard;
  }

  static isDate () {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    return formattedDate.toString();
  }

  static computeTransaction () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionDeltails = sharedPrefs.getString('TransactionsDetails');
    if(TransactionDeltails != null) {
      List<dynamic> _transactions = jsonDecode(TransactionDeltails);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat.yMMMMd().format(now);
      var _toLatestDates = _transactions;
      for(var i=0;i<_toLatestDates.length/2;i++){
        var temp = _toLatestDates[i];
        _toLatestDates[i] = _toLatestDates[_toLatestDates.length-1-i];
        _toLatestDates[_toLatestDates.length-1-i] = temp;
      }
      List _profits = _transactions.map((transaction) {
        return transaction['dates'] == formattedDate.toString() ? double.parse(transaction['amount']) : 0;
      }).toList();

      double _profitAmount = _profits.fold(0, (i, j) => i + j);

      return _profitAmount.toString();
    } else {
      return 0;
    }
  }

}
