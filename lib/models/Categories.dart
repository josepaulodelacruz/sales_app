import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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



}
