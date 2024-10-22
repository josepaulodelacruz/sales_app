import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/models/Products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListProducts {
  List products;

  //constructor
  ListProducts({
    this.products,
  });

  static remaningWorthOfItems() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic ListProducts = sharedPrefs.getString('ListProducts');
    if(ListProducts == null) {
      double a = 0;
      return a;
    } else {
      List<dynamic> decodedFiles = jsonDecode(ListProducts);
      List worthItems = decodedFiles.map((item) {
        return item['pPrice'] * item['pQuantity'];
      }).toList();
      double total = worthItems.fold(0, (prev, next) => prev + next);
      return total;
    }
  }

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

  static fetchProductFromCloud (products) async {
    if(products.isEmpty) return false;

    List<dynamic> _categories = await Categories.getCategoryLocalStorage();
    products.map((product) {
      _categories.add({
        'cTitle': product['pCategory'],
        'isValid': true,
      });

    }).toList();

    await Categories.saveCategoryToLocalStorage(_categories);
    await ListProducts.saveProductToLocalStorage(products);

    return true;
  }

  static saveProductToLocalStorage (products) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(products);
    sharedPrefs.setString('ListProducts', decode);
  }

  static resetProductInventory () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode([]);
    sharedPrefs.setString('ListProducts', decode);
  }

}
