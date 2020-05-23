import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:badges/badges.dart';

//component
import '../../components/ProductCard.dart';
import '../../models/ListProducts.dart';
import '../../utils/colorParser.dart';
import 'ViewItems.dart';


const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class BarcodeScan extends StatefulWidget {
  const BarcodeScan({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _products = [];
  List _soldItems = [];
  bool _isScan = false;
  final _scanItem = TextEditingController();
  Map<String, dynamic> item = {};
  int _orderCount = 1;
  Timer _timer;
  bool _isCameraMounted = false;
  int _itemCounter = 0;
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 1000), () {
      setState(() {
        _isCameraMounted = true;
      });
      _fetchLocalStorage();
      print(_products);
    });
  }


  _fetchLocalStorage () async {
    List _items = await ListProducts.getProductLocalStorage();
    setState(() {
      _products = _items;
    });
  }

  @override
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!_isScan) {
          setState(() {
            _isScan = true;
            _scanItem.text = scanData;
          });
          dynamic result = _products.where((pp) {
            String codeString = pp['pCode'].toString();
            return codeString.contains(_scanItem.text);
          }).toList();
          setState(() {
            item = result[0];
          });
        }
      }
    );
  }


  @override
  void dispose () {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Barcode Scanner')
      ),
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: _isCameraMounted ? 1 : 0,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.87,
            child: Column(
              children: <Widget>[
//                Flexible(
//                  flex: 2,
//                  child: QRView(
//                    key: qrKey,
//                    onQRViewCreated: _onQRViewCreated,
//                    overlay: QrScannerOverlayShape(
//                      borderColor: Colors.red,
//                      borderRadius: 10,
//                      borderLength: 30,
//                      borderWidth: 10,
//                      cutOutSize: 300,
//                    ),
//                  ),
//                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          color: Colors.blue,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _scanItem,
                                  onChanged: (val) {
                                    _products.map((x) {
                                      if(x['pCode'].toString() == val) {
                                        setState(() {
                                          item = x;
                                        });
                                      }
                                    }).toList();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Scan items'
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: false,
                                    signed: true,
                                  )
                                )
                              ),
                              FlatButton(
                                child: Icon(Icons.close, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    _isScan = false;
                                    _scanItem.text = '';
                                    item = {};
                                    _orderCount = 1;
                                  });
                                },
                              ),
                              RaisedButton(
                                  child: Text('Add'),
                                  onPressed: ()  {
                                    if(item.isNotEmpty) {
                                      setState(() {
                                        _soldItems.add({'orderCount': _orderCount, ...item });
                                        item = {};
                                        _scanItem.text = '';
                                        _isScan = false;
                                        _orderCount = 1;
                                      });
                                    } else {
                                      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('No items added.')));
                                    }

                                  },
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              )
                            ],
                          )
                        ),
                        item.isEmpty ? Text('No items scan') : Container(
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
                                        Image.file(
                                          File(item['pImagePath']),
                                          height: MediaQuery.of(context).size.height * 0.15,
                                          width: MediaQuery.of(context).size.width,
                                        ),
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
                                                child: Text('Product Name:', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
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
                                                child: Text('Quantity:', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: TextField(
                                                  textAlign: TextAlign.right,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      _orderCount = val.length > 0 ? int.parse(val): 1;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: '1'
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
                                              Flexible(
                                                child: Text('Price:', style: TextStyle(fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                              ),
                                              Text('P${item['pPrice'] * _orderCount}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                                            ]
                                          )
                                        ),

                                        Text('Barcode: ${item['pCode']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
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
                  )
                )
              ],
            )
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'soldItems',
        onPressed: () {
          Navigator.push(context, PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, a1, a2) => ViewItems(
              products: _soldItems,
              deleteItem: (String id) {
                setState(() {
                  _soldItems.removeWhere((p) => p['pId'] == id);
                });
              }
            ),
          ));
        },
        child: Badge(
          toAnimate: true,
          animationType: BadgeAnimationType.scale,
          animationDuration: Duration(milliseconds: 300),
          badgeContent: Text(_soldItems.length <= 9 ? _soldItems.length.toString() : '9+', style: TextStyle(fontSize: 12, color: Colors.white)),
          child: Icon(Icons.add_shopping_cart),
        )
      ),
    );
  }
}
