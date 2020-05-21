import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListProducts {
  List products;

  //constructor
  ListProducts({
    this.products,
  });

  static getProductLocalStorage () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic ListProducts = sharedPrefs.getString('ListProducts');
    List<dynamic> decodedFiles = jsonDecode(ListProducts);
    return decodedFiles;

  }

}
