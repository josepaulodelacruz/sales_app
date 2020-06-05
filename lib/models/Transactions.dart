import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Transactions {
  String productName;
  double amount;
  int quantity;

  Transactions({this.productName, this.amount, this.quantity});

  static frequentlyBought () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionsDetails = sharedPrefs.getString('TransactionsDetails');
    if(TransactionsDetails == null) {
      return null;
    } else {
      List _frequentlyBought = [];
      List<dynamic> decodedFiles = jsonDecode(TransactionsDetails);
      List _productName = decodedFiles.map((p) => p['productName']).toList();
      List removeDuplicateElement = _productName.toSet().toList();
      await ListProducts.getProductLocalStorage().then((res) {
        removeDuplicateElement.map((p) {
          res.map((product) {
            if(p == product['pName']) {
              _frequentlyBought.add({
                'id': product['pId'],
                'name': product['pName'],
                'imagePath': product['pImagePath'],
                'price': product['pPrice'],
              });
            }
          }).toList();
        }).toList();
      });

      for(var i=0;i<_frequentlyBought.length/2;i++){
        var temp = _frequentlyBought[i];
        _frequentlyBought[i] = _frequentlyBought[_frequentlyBought.length-1-i];
        _frequentlyBought[_frequentlyBought.length-1-i] = temp;
      }

      return _frequentlyBought == null ? [] : _frequentlyBought;
    }
  }

  static totalItemSale () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionsDetails = sharedPrefs.getString('TransactionsDetails');
    if(TransactionsDetails == null) {
      return 0;
    } else {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat.yMMMMd().format(now);
      List<dynamic> decodedFiles = jsonDecode(TransactionsDetails);
      List<dynamic> _totalItemSold = decodedFiles.map((item) {
        return item['dates'] == formattedDate.toString() ? item['quantity']: 0;
      }).toList();
      int isTotal = _totalItemSold.fold(0, (previousValue, element) => previousValue + element);
      return isTotal;
    }
  }

  static getTransactionsDetails () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionsDetails = sharedPrefs.getString('TransactionsDetails');
    if(TransactionsDetails == null) {
      return null;
    } else {
      List<dynamic> decodedFiles = jsonDecode(TransactionsDetails);
      return decodedFiles;
    }
  }

  static saveTransactionsDetails (products) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic TransactionsDetails = sharedPrefs.getString('TransactionsDetails');

    if(TransactionsDetails == null) {
      List<dynamic> uncodeDetails = [];
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
    } else {
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

  static resetTransactionDetails () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode([]);
    sharedPrefs.setString('TransactionsDetails', decode);
  }

}
