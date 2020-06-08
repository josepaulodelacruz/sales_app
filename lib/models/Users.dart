import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Users extends ChangeNotifier {
  String name;
  String address;
  String contact;
  String email;
  String password;
  String confirmPassword;
  String uuid;
  String imagePath;
  String status;

  int _counter = 20;
  Map<String, dynamic> loggedUser;
  int get counter => _counter;

  set counter (int val) {
    _counter = val;
    notifyListeners();
  }

  void loginUser(Map<String, dynamic>jsonUser) {
    loggedUser = jsonUser;
    notifyListeners();
  }

  userInfoStorage() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic user = sharedPrefs.getString('user');
    Map<String, dynamic> decode = jsonDecode(user);
    return decode;
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

  validateUserInputs (user) {
    if(user.name == null || user.address == null || user.contact == null || user.email == null || user.password == null || user.confirmPassword == null) {
      return false;
    } else {
      return true;
    }
  }

  static getSession () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final logStatus = sharedPrefs.get('session');
    if(logStatus == null) {
      return false;
    } else {
      final _auth = FirebaseAuth.instance;
      dynamic decode = jsonDecode(logStatus);
      Map<String, dynamic> session = {
        'isLoggedIn': decode['isLoggedIn'],
        'created_data': DateTime.parse(decode['created_data']),
        'expiration': DateTime.parse(decode['expiration']),
      };

      DateTime now = DateTime.now();
      DateTime currentDate = session['created_data'];
      DateTime expirationDate = session['expiration'];
      if(currentDate.isAfter(expirationDate)) {
        await _auth.signOut();
        session['isLoggedIn'] = false;
        return session;
      } else {
        return session;
      }
    }
  }

  static saveSession (isLogged) async {
    DateTime now = DateTime.now();
    DateTime tokenExpiration = now.add(Duration(days: 3));
    Map<String, dynamic> session = {
      'isLoggedIn': isLogged,
      'created_data': now.toString(),
      'expiration': tokenExpiration.toString(),
    };
    print(session);
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(session);
    sharedPrefs.setString('session', decode);
  }

  static userGetStatusPersistent () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic getStatus = sharedPrefs.getString('status');
    final decode = jsonDecode(getStatus);
    return decode;
  }

  static userSaveStatusPersistent (status) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(status);
    sharedPrefs.setString('status', decode);
  }

  static getStorageImage () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic storeImage = sharedPrefs.getString('storeImage');
    if(storeImage == null ) {
      return null;
    } else {
      String imagePath = jsonDecode(storeImage);
      return imagePath;
    }
  }

  static saveStorageImage (storeImagePath) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(storeImagePath);
    sharedPrefs.setString('storeImage', decode);
  }

  static getUserInformation () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic user = sharedPrefs.getString('user');
    if(user == null) {
      return 'not found';
    } else {
      Map<String, dynamic> decode = jsonDecode(user);
      return decode;
    }

  }

  static saveUserInformation (user) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(user);
    sharedPrefs.setString('user', decode);
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'contact': contact,
        'address': address,
        'email': email,
      };

}
