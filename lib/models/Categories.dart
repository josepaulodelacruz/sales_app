import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sari_sales/models/ListProducts.dart';

class Categories {
  String categoryImagePath;
  String category;

  Categories({
    this.category,
    this.categoryImagePath,
  });

  static toJson(String category) {
    if(category == '') {
      return {'isValid': false };
    } else {
      return {
        'cTitle': category,
        'isValid': true
      };
    }

  }

  static getCategoryLocalStorage () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic categories = sharedPrefs.getString('categories');
    if(categories == null) {
      return [{'cTitle': 'All', 'isValid': true}];
    } else {
      List<dynamic> decodedFiles = jsonDecode(categories);
      return decodedFiles;
    }

  }

  static saveCategoryToLocalStorage (categories) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(categories);
    sharedPrefs.setString('categories', decode);
    return 'save';
  }

  static resetCategories () async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode([{'cTitle': 'All', 'isValid': true}]);
    sharedPrefs.setString('categories', decode);
  }

  static deleteCategory (categoryName, index) async {
    List updateProducts = [];
    List updateCategories = [];
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    dynamic categories = sharedPrefs.getString('categories');
    List products = await ListProducts.getProductLocalStorage();
    products.removeWhere((product) => product['pCategory'] == categoryName);
    List decodedFiles = jsonDecode(categories);
    decodedFiles.removeAt(index);


    final decodeProducts = json.encode(products);
    final decodeCategories = json.encode(decodedFiles);
    sharedPrefs.setString('categories', decodeCategories);
    sharedPrefs.setString('ListProducts', decodeProducts);

  }

}
