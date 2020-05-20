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
      this.productExpiration
  });

  Products.addProduct(Map<String, dynamic> json) {
    productName = json['pName'];
    productCode = json['pCode'];
  }



}
