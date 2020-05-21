import 'package:flutter/material.dart';

class Products {
  String productName;
  int productCode;
  String productCategory;
  String productPrice;
  String productQuantity;
  String productDescription;
  String productExpiration;

  //constructor
  Products({
      this.productName,
      this.productCode,
      this.productCategory,
      this.productPrice,
      this.productQuantity,
      this.productDescription,
      this.productExpiration,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productName: json['pName'],
    );
  }

  static toJson(String pName, String pCode, String pCategory, String pPrice,String pQuantity, String pDescription, String pExpiration) {
    if(pName == '') {
      return {'error': 'invalid'};
    } else {
      return {
        'pName': pName,
//        'pCode': int.parse(pCode),
//        'pCategory': pCategory,
//        'pPrice': double.parse(pPrice),
//        'pQuantity': int.parse(pQuantity),
//        'pDescription': pDescription,
//        'pExpiration': pExpiration,
      };
    }

  }



}
