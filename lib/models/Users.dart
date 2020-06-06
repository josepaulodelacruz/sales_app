import 'package:flutter/material.dart';

class Users {
  String name;
  String address;
  String contact;
  String email;
  String password;
  String confirmPassword;

  Users({String userName, String userAddress, String userContact, String userEmail, String userPassword, String userConfirmPassword}) {
    name = userName;
    address = userAddress;
    contact = userContact;
    email = userEmail;
    password = userPassword;
    confirmPassword = userConfirmPassword;
  }

  static validateUserInputs (user) {
//    print(user.name);
//    print(user.address);
//    print(user.contact);
//    print(user.email);
//    print(user.password);
//    print(user.confirmPassword);
    if(user.name == null || user.address == null || user.contact == null || user.email == null || user.password == null || user.confirmPassword == null) {
      return false;
    } else {
      return true;
    }
  }


}
