import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sari_sales/components/ProductCard.dart';
import 'package:sari_sales/models/Contact.dart';
import 'dart:collection';
import 'dart:core';

class ContactData extends ChangeNotifier {
  String persistName = '';
  String persistPhone = '';
  String persistSupply = '';
  String persistImagePath;

  String get imagePath {
    return persistImagePath;
  }

  _resetInputs () {
    persistName = '';
    persistPhone = '';
    persistSupply = '';
    persistImagePath = null;
  }

  //save path image
  persistImage (String imagePath) {
    print(imagePath);
    persistImagePath= imagePath;
    notifyListeners();
  }

  handleSubmit () async {
    final contactInfo = Contact(name: persistName, phone: persistPhone, supply: persistSupply, imagePath: persistImagePath);
    bool isValid = contactInfo.isValidate(contactInfo.toJson());
    if(!isValid) {
      print('Please Complete all the data');
    } else {
      Contact.saveContacts(contactInfo.toJson());
      _resetInputs();
      notifyListeners();
    }
  }

  handleEdit (Map<String, dynamic> editContact) async {
    Map<String, dynamic> user = {
      'name': editContact['name'].text,
      'contact': editContact['contact'].text,
      'imagePath': editContact['imagePath'],
      'supply': editContact['supply'].text,
      'id': editContact['id'],
    };
    print('edit');
    await Contact.editContact(user);

  }


}
