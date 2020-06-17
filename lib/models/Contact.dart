import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sari_sales/providers/contact_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
    var uuid = Uuid();
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    List getContacts = await getContact();
    getContacts.add({...contacts, 'id': uuid.v4()});
    final encode = json.encode(getContacts);
    sharedPrefs.setString('contacts', encode);
    print('succcessfully save in the storage');
  }

  static editContact (contact) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    List<dynamic> contacts = await getContact();
    List updatedContacts = contacts.map((c) {
      if(c['id'] == contact['id']) {
        return contact;
      }
      return c;
    }).toList();

    final encode = json.encode(updatedContacts);
    sharedPrefs.setString('contacts', encode);

  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'contact': phone,
        'supply': supply,
        'imagePath': imagePath,
      };




}
