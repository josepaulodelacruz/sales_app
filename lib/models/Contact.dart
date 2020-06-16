import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sari_sales/providers/contact_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Contact {
  String name;
  String phone;
  String supply;
  String imagePath;

  Contact({@required this.name, @required this.phone, @required this.supply, @required this.imagePath});

  isValidate (Map<String, dynamic> info) {
    return (info['name'] == '' ||  info['phone'] == '' || info['supply'] == '') ? false : true;
  }

  static getContact () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final getContacts = sharedPrefs.getString('contacts');
    if(getContacts == null) {
      return [];
    } else {
      List<dynamic> decode = jsonDecode(getContacts);
      return decode;
    }
  }

  static saveContacts (contacts) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    List getContacts = await getContact();
    getContacts.add(contacts);
    final encode = json.encode(getContacts);
    sharedPrefs.setString('contacts', encode);
    print('succcessfully save in the storage');
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'contact': phone,
        'supply': supply,
        'imagePath': imagePath,
      };




}
