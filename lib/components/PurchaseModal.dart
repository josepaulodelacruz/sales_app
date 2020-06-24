import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';

class ConfirmPurchase extends StatefulWidget {
  @override
  _ConfirmPurchase createState () => _ConfirmPurchase();
}

class _ConfirmPurchase extends State<ConfirmPurchase>{
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
  void initState () {
    _initialize();
    super.initState();
  }

  @override
  void dispose () {
//    _subscription.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _iap.isAvailable();
    if(_available) {
      await _getProducts();

      _verifyPurchase();
    }


  }

  Future<void> _getProducts () async {
    Set<String> ids = Set.from(['1_monthly']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
    });
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
  }


  void _verifyPurchase () {
    PurchaseDetails purchase = _hasPurchased('1_monthly');
  }

  void _buyProduct() {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: _products[0]);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getColorFromHex('#00d2ff'),
                    getColorFromHex('#3a7bd5'),
                  ],
                ),
              ),
              child: Center(
                child: Text('Subscription', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    _textList(title: 'Unlimited Inventory Storage'),
                    _textList(title: 'Share your data to anyone'),
                    _textList(title: 'Save your data in the cloud'),
                    Text('For only: ₱129.00/month', style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                      height: 3,
                      fontWeight: FontWeight.w400
                    ))
                  ],
                )
              )
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            getColorFromHex('#FF416C'),
                            getColorFromHex('#FF4B2B'),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        )
                      ),
                    )
                  )
                ),
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: _buyProduct,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            getColorFromHex('#AAFFA9'),
                            getColorFromHex('#11FFBD'),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Text(
                              'Yes',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          )
                      ),
                    )
                  )
                )
              ],
            )
          ],
        )
      ),
    );
  }

  Container _textList ({title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w300
            )
          ),
          Icon(Icons.check, color: Colors.green, size: 32)
        ],
      )
    );
  }
}
