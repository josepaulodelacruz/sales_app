import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sari_sales/utils/colorParser.dart';

class BottomModal extends StatefulWidget {
  List products;
  Function addProduct;

  BottomModal({Key key, this.products, this.addProduct }) : super(key: key);

  @override
  createState () => _BottomModal();
}

class _BottomModal extends State<BottomModal> {
  final _productTerm = TextEditingController();
  int _orderCount = 1;
  List _products;
  Map<String, dynamic> item = {};

  @override
  void initState () {
    setState(() {
      _products = widget.products;
    });
  }

  _fuzzySearchProduct (String val) {
    List searchProducts = _products.where((element) => element['pName'].toString().toLowerCase().contains(val.toLowerCase())).toList();
    setState(() {
      item = val != '' ? searchProducts[0] : {};
    });
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Product Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              controller: _productTerm,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (val) {
                _fuzzySearchProduct(val);
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      item = {};
                      _productTerm.text = '';
                    });
                  },
                )
              ),
            ),
            item.isNotEmpty ? Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: getColorFromHex('#373234'),
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              item['pImagePath'] != null ? Image.file(
                                File(item['pImagePath']),
                                fit: BoxFit.contain,
                              ) : Image.asset(
                                'images/noImage.png',
                                fit: BoxFit.contain,
                              )
                            ],
                          )
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('Product Name: ', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                  ),
                                  Text('${item['pName']}', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                ]
                              )
                            ),
                            Container(
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Text('Stocks:', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: TextField(
                                      showCursor: true,
                                      readOnly: true,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                          hintText: '${item['pQuantity']}'
                                      ),
                                      keyboardType: TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: true,
                                      ),
                                    )
                                  ),
                                ]
                              )
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Price ${item['pPrice'] * _orderCount}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                                ]
                              )
                            ),
                          ],
                        )
                      )
                    )
                  ],
                )
              )
            ) : SizedBox(),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                widget.addProduct(item);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}


