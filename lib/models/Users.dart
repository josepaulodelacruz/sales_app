import 'dart:convert';
import 'dart:math';
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
      dynamic decode = jsonDecode(logStatus);
      return decode;
    }
  }

  static saveSession (isLogged) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(isLogged);
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
