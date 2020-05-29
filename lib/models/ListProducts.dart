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
    if(ListProducts == null) {
      return [];
    } else {
      List<dynamic> decodedFiles = jsonDecode(ListProducts);
      return decodedFiles;
    }
  }

  static saveProductToLocalStorage (products) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(products);
    sharedPrefs.setString('ListProducts', decode);

  }

}
