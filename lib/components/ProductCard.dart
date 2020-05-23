import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/categoriesList.dart';
import '../utils/colorParser.dart';

class ProductCard extends StatefulWidget {
  Map<String, dynamic> productInfo;
  Function isEdit;
  Function isDelete;
  int productIndex;

  ProductCard({Key key, this.productInfo, this.productIndex, this.isEdit, this.isDelete }) : super(key: key);

  @override
  createState () => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Map<String, dynamic> _productInfo;

  void initState () {

    setState(() {
      _productInfo = widget.productInfo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 175,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                          Text((widget.productIndex + 1).toString(), style: TextStyle(color: Colors.white)),
                          Image.file(
                            File(_productInfo['pImagePath']),
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Expiration: ${_productInfo['pExpiration']}', style: TextStyle(fontSize: 12, color: Colors.white)),
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
                                  child:
                                  Text('${_productInfo['pName']}', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          widget.isEdit(widget.productIndex);
                                        },
                                        icon: Icon(Icons.edit, color: Colors.blue)
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          widget.isDelete(widget.productInfo['pId']);
                                        },
                                        icon: Icon(Icons.delete, color: Colors.redAccent)
                                      ),
                                    ]
                                  )
                                )
                              ]
                            )
                          ),
                          Text('Price: P${_productInfo['pPrice']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('Quantity:  ${_productInfo['pQuantity']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('Barcode: ${_productInfo['pCode']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                        ],
                      )
                    )
                  )
                ],
              )
            )
          ),
        ],
      )
    );
  }
}
