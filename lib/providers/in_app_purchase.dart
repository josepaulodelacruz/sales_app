import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'dart:io';

class InApp extends ChangeNotifier {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  bool _available;


  @override
  void initial() {
    _initialize();
  }



  /// Initialize data
  _initialize() async {
    _available = await _iap.isAvailable();

    if (_available) {

      return await getProducts();

    }
  }


  /// Get all products available for sale
  Future getProducts() async {
    Set<String> ids = Set.from(['1_monthly']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

//    print(response.productDetails);
//    print(response.productDetails[0].skuDetail.title);
//    print(response.productDetails[0].skuDetail.price);
//    print(response.productDetails[0].skuDetail.description);
//    print(response.productDetails[0].skuDetail.sku);
    return response.productDetails[0];
  }



}
