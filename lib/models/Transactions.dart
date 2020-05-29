import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Transactions {
  String productName;
  double amount;
  int quantity;

  Transactions({this.productName, this.amount, this.quantity});

  static getTransactionsDetails () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionsDetails = sharedPrefs.getString('TransactionsDetails');
    List<dynamic> decodedFiles = jsonDecode(TransactionsDetails);
    return decodedFiles;
  }

  static saveTransactionsDetails (products) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionsDetails = sharedPrefs.getString('TransactionsDetails');
    List<dynamic> uncodeDetails = jsonDecode(TransactionsDetails);
    List<dynamic> _details = products.map((product) {
      uncodeDetails.add({
        'dates': formattedDate.toString(),
        'productName': product['pName'],
        'amount': (product['pPrice'] * product['orderCount']).toString(),
        'quantity': product['orderCount'],
      });
    }).toList();
    final decode = json.encode(uncodeDetails);
    sharedPrefs.setString('TransactionsDetails', decode);
  }

}
