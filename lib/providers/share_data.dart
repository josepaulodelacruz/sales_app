import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sari_sales/models/Categories.dart';

import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Products.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/models/Loans.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sari_sales/models/Users.dart';

class ShareData extends ChangeNotifier {
  bool _isError = false;
  String id;
  List _products = [
    Products(productName: 'test')
  ];

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
    final _firestore = Firestore.instance;
    DocumentSnapshot querySnapshot = await _firestore.collection('shared').document(isUser['shortId']).get();

    return querySnapshot.data;
  }

  Future<Map<String, dynamic>> shareTransactions (List obj) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    if(id != '') {
      try {
        final _auth = FirebaseAuth.instance;
        final _firestore = Firestore.instance;
        final userId = await _auth.currentUser();
        DocumentSnapshot senderSnapshot = await Firestore.instance.collection('users').document(userId.uid).get();
        DocumentSnapshot querySnapshot = await Firestore.instance
            .collection('shared')
            .document(id)
            .get();
        _firestore.collection('shared').document(id).setData({
          'sender': senderSnapshot.data['name'],
          'date_send': formattedDate.toString(),
          'owner': querySnapshot.data['owner'],
          'primary_id': querySnapshot.data['primary_id'],
          'sales': obj,
          'loans': querySnapshot.data['loans'],
          'inventory': querySnapshot.data['inventory']
        });
        return {'error': false, 'titleError': 'Upload Success', 'message': 'You successfully shared\nyour transactions'};
      } catch (e) {
        return {'error': true, 'titleError': 'Failed', 'message': 'Something went wrong\nPlease try again'};
      }
    }

    return {'error': true, 'titleError': 'User ID is Empty', 'message': 'Please enter an ID'};
  }

  Future<Map<String,dynamic>> shareLoans (List obj) async {
    Map<String, dynamic > _user = await Users.getUserInformation();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    if(id != '') {
      try {
        final _auth = FirebaseAuth.instance;
        final userId = await _auth.currentUser();
        final _firestore = Firestore.instance;
        DocumentSnapshot senderSnapshot = await Firestore.instance.collection('users').document(userId.uid).get();
        DocumentSnapshot querySnapshot = await Firestore.instance
            .collection('shared')
            .document(id)
            .get();
        _firestore.collection('shared').document(id).setData({
          'sender': senderSnapshot.data['name'],
          'date_send': formattedDate.toString(),
          'owner': querySnapshot.data['owner'],
          'primary_id': querySnapshot.data['primary_id'],
          'sales': querySnapshot.data['sales'],
          'loans': obj.map((loan) {
            return {
              ...loan,
              'imagePath': _user['shortId'] == id ? loan['imagePath'] : null,
              'signature': _user['shortId'] == id ? loan['signature'] : null,
            };
          }).toList(),
          'inventory': querySnapshot.data['inventory']
        });
        return {'error': false, 'titleError': 'Upload Success', 'message': 'You successfully shared\nyour Loans'};
      } catch(e) {
        return {'error': true, 'titleError': 'Failed', 'message': 'Something went wrong\nPlease try again'};
      }
    }
    return {'error': true, 'titleError': 'User ID is Empty', 'message': 'Please enter an ID'};
  }

  Future<Map<String, dynamic>> shareInventory (List obj) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    Map<String, dynamic > _user = await Users.getUserInformation();
    if(id != '') {
      try {
        final _auth = FirebaseAuth.instance;
        final userId = await _auth.currentUser();
        final _firestore = Firestore.instance;
        DocumentSnapshot senderSnapshot = await Firestore.instance.collection('users').document(userId.uid).get();
        DocumentSnapshot querySnapshot = await Firestore.instance
            .collection('shared')
            .document(id)
            .get();
        _firestore.collection('shared').document(id).setData({
          'sender': senderSnapshot.data['name'],
          'date_send': formattedDate.toString(),
          'owner': querySnapshot.data['owner'],
          'primary_id': querySnapshot.data['primary_id'],
          'sales': querySnapshot.data['sales'],
          'loans': querySnapshot.data['loans'],
          'inventory': obj.map((item) {
            return {
              ...item,
              'pImagePath': _user['shortId'] == id ? item : null,
            };
          }).toList(),
        });
        return {'error': false, 'titleError': 'Upload Success', 'message': 'You successfully shared\nyour Inventory'};
      } catch (e) {
        return {'error': true, 'titleError': 'Failed', 'message': 'Something went wrong\nPlease try again'};
      }
    }
    return {'error': true, 'titleError': 'User ID is Empty', 'message': 'Please enter an ID'};
  }




}
