import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Loans {
  String id;
  String first;
  String last;
  String contact;
  String address;
  String signature;
  String imagePath;
  String createdAt;

  Loans({
    @required String firstName,
    @required String lastName,
    @required String contactNumber,
    @required String personalAddress,
    @required String personalSignature,
    @required image,
    @required uid,
  }) {
    first= firstName;
    last= lastName;
    contact= contactNumber;
    address = personalAddress;
    signature = personalSignature;
    imagePath = image;
    id = uid;
  }

  static isValidate (info) {
    if(info.first == '' || info.last == '' || info.contact == '' || info.address == '' || info.signature == null || info.imagePath == null ) {
      return false;
    }
    return true;
  }

  static addItemLoan (_products, person) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic _LoansList = sharedPrefs.getString('LoansList');
    List<dynamic> decodedFiles = jsonDecode(_LoansList);
    decodedFiles.map((people) {
      int index = decodedFiles.indexOf(people);
      if(people['id'] == person['id']) {
        _products.map((product) {
          decodedFiles[index]['loans'].insert(0, {...product, 'date': formattedDate.toString()});
        }).toList();
      }
    }).toList();

    final decode = json.encode(decodedFiles);
    sharedPrefs.setString('LoansList', decode);
  }

  static deleteLoan (id, loanIndex) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic _LoansList = sharedPrefs.getString('LoansList');
    List<dynamic> _loanList = jsonDecode(_LoansList);

    _loanList.map((loan) {
      if(loan['id'] == id) {
        loan['loans'].removeAt(loanIndex);
        return;
      }
    }).toList();

    final decode = json.encode(_loanList);
    sharedPrefs.setString('LoansList', decode);


  }

  static getLoanInformation () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic _LoansList = sharedPrefs.getString('LoansList');
    if(_LoansList == null) {
      return [];
    } else {
      List<dynamic> decodedFiles = jsonDecode(_LoansList);
      return decodedFiles;
    }

  }

  static saveLoanInformation (info) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic _LoansList = sharedPrefs.getString('LoansList');

    if(_LoansList == null) {
      List<dynamic> _loans = [];
      _loans.add({
        ...info,
        'created_at': formattedDate.toString(),
        'loans': [],
      });
      final decode = json.encode(_loans);
      sharedPrefs.setString('LoansList', decode);
    } else {
      List<dynamic> _loans = jsonDecode(_LoansList);
      _loans.add({
        ...info,
        'created_at': formattedDate.toString(),
        'loans': [],
      });
      final decode = json.encode(_loans);
      sharedPrefs.setString('LoansList', decode);
    }
  }

  static fetctLoansFromCloud (loans) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(loans);
    sharedPrefs.setString('LoansList', decode);
    return true;
  }

  static resetLoanList () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode([]);
    sharedPrefs.setString('LoansList', decode);
  }

  Map<String, dynamic> toJson() =>
    {
      'first': first,
      'last': last,
      'contact': contact,
      'address': address,
      'signature': signature,
      'imagePath': imagePath,
      'id': id,
    };

}
