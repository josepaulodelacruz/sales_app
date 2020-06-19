import 'package:flutter/foundation.dart';
import 'package:sari_sales/models/Categories.dart';

import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Products.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/models/Loans.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sari_sales/models/Users.dart';

class ShareData extends ChangeNotifier {
  bool _isError = false;
  String id = 'b83f2242';
  List _products = [
    Products(productName: 'test')
  ];
  List _transactions = [];
  List _loans = [];

  bool get isError => _isError;
  String get searchId => id;

  void isLoading () {
    _isError = !_isError;
    notifyListeners();
  }

  List get products {
    return _products;
  }

  Future<Map<String, dynamic>> fetchData () async {
    Map<String, dynamic> isUser = await Users.getUserInformation();
    print(isUser);
    final _firestore = Firestore.instance;
    DocumentSnapshot querySnapshot = await _firestore.collection('shared').document(isUser['shortId']).get();

    List <dynamic> staticCategories = await Categories.getCategoryLocalStorage();
    querySnapshot.data['inventory'].map((item) {
      staticCategories.add({
        'cTitle': item['pCategory'],
        'isValid': true
      });
    }).toList();

    await Categories.saveCategoryToLocalStorage(staticCategories);

    return querySnapshot.data;
  }

  Future<List> shareTransactions (List obj) async {
    if(id != '') {
      final _firestore = Firestore.instance;
      DocumentSnapshot querySnapshot = await Firestore.instance
          .collection('shared')
          .document(id)
          .get();
      _firestore.collection('shared').document(id).setData({
        'owner': querySnapshot.data['owner'],
        'primary_id': querySnapshot.data['primary_id'],
        'sales': obj,
        'loans': querySnapshot.data['loans'],
        'inventory': querySnapshot.data['inventory']
      });
      return [{'error': false}];
    }

    return [{'error': true}];
  }

  Future<List> shareLoans (List obj) async {
    if(id != '') {
      final _firestore = Firestore.instance;
      DocumentSnapshot querySnapshot = await Firestore.instance
          .collection('shared')
          .document(id)
          .get();
      _firestore.collection('shared').document(id).setData({
        'owner': querySnapshot.data['owner'],
        'primary_id': querySnapshot.data['primary_id'],
        'sales': querySnapshot.data['sales'],
        'loans': obj,
        'inventory': querySnapshot.data['inventory']
      });
      return [{'error': false}];
    }

    return [{'error': true}];

  }

  Future<List> shareInventory (List obj) async {
    if(id != '') {
      final _firestore = Firestore.instance;
      DocumentSnapshot querySnapshot = await Firestore.instance
          .collection('shared')
          .document(id)
          .get();
      _firestore.collection('shared').document(id).setData({
        'owner': querySnapshot.data['owner'],
        'primary_id': querySnapshot.data['primary_id'],
        'sales': querySnapshot.data['sales'],
        'loans': querySnapshot.data['loans'],
        'inventory': obj
      });
      return [{'error': false}];
    }

    return [{'error': true}];


  }




}
