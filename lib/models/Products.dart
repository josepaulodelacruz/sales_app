import 'package:flutter/material.dart';

class Products {
  String productId;
  String productName;
  String productCode;
  String productCategory;
  String productPrice;
  String productQuantity;
  String productDescription;
  String productExpiration;
  String productImagePath;

  //constructor
  Products({
      this.productId,
      this.productName,
      this.productCode,
      this.productCategory,
      this.productPrice,
      this.productQuantity,
      this.productDescription,
      this.productExpiration,
      this.productImagePath,
  });

  static toJson(String pId, String pName, String pCode, String pCategory, String pPrice,String pQuantity, String pDescription, String pExpiration, String pImagePath) {
    if(pName == '' || pCategory == 'All' || pPrice == '' || pQuantity == '' || pImagePath == null) {
      print('inavlid');
      return {'error': 'Invalid inputs please fill up all the information.', 'invalid': true};
    } else {
      print('true');
      return {
        'pId': pId,
        'pName': pName,
        'pCode': pCode == '' ? 0 : int.parse(pCode),
        'pCategory': pCategory,
        'pPrice': double.parse(pPrice),
        'pQuantity': int.parse(pQuantity),
        'pDescription': pDescription,
        'pExpiration': pExpiration,
        'pImagePath': pImagePath,
        'invalid': false,
      };
    }

  }



}
