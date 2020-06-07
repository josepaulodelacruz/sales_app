import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends ChangeNotifier {
  String name;
  String address;
  String contact;
  String email;
  String password;
  String confirmPassword;
  String uuid;
  String imagePath;

  int _counter = 10;
  int get counter => _counter;

  set counter (int val) {
    _counter = val;
    notifyListeners();
  }


  Users({String userName, String userAddress, String userContact, String userEmail, String userPassword, String userConfirmPassword, String uid, String path}) {
    name = userName;
    address = userAddress;
    contact = userContact;
    email = userEmail;
    password = userPassword;
    confirmPassword = userConfirmPassword;
    uuid: uid;
    imagePath: path;
  }

  static validateUserInputs (user) {
    if(user.name == null || user.address == null || user.contact == null || user.email == null || user.password == null || user.confirmPassword == null) {
      return false;
    } else {
      return true;
    }
  }

  static getUserInformation () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic user = sharedPrefs.getString('user');
    final decode = jsonDecode(user);
    return user;
  }

  static saveUserInformation (Map<String, dynamic> user) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(user);
    sharedPrefs.setString('user', decode);
  }

  Map<String, dynamic> toJson() =>
      {
        'first': name,
        'contact': contact,
        'address': address,
        'email': email,
        'uid': uuid,
        'imagePath': imagePath
      };

}
