import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:badges/badges.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:sari_sales/constants/colorsSequence.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';
import 'package:sari_sales/components/BottomModal.dart';

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
  bool loanActive;
  Map<String, dynamic> personalLoan;
  BarcodeScan({
    Key key,
    this.loanActive,
    this.personalLoan,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _flashCamera = false;
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
        final player = AudioCache();
        setState(() => _isScan = true);
        player.play('beep.mp3').then((res) {
            //synchronize beep
            Timer(Duration(milliseconds: 100), () {
              setState(() {
                _scanItem.text = scanData;
              });
              dynamic result = _products.where((pp) {
                String codeString = pp['pCode'].toString();
                return codeString.contains(_scanItem.text);
              }).toList();
              setState(() {
                item = result[0];
              });
            });
          });
        }
      }
    );
  }


  _addToCart () {
    if(item.isNotEmpty) {
      List hasDuplicate = _soldItems.where((element) => element['pName'].toString().toLowerCase().contains(item['pName'].toString().toLowerCase())).toList();
      //if has duplicate items in cart
      if(hasDuplicate.isEmpty) {
        setState(() {
          _soldItems.add({'orderCount': _orderCount, ...item });
          item = {};
          _scanItem.text = '';
          _isScan = false;
          _orderCount = 1;
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('Your item already exist in the cart.')));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('No items added.')));
    }

  }


  @override
  void dispose () {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      },
        child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: getColorFromHex('#20BDFF'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
            },
          ),
          title: Text('Barcode Scanner'),
          actions: [
            IconButton(
              icon: Icon(_flashCamera ? Icons.flash_on : Icons.flash_off, color: Colors.white),
              onPressed: () {
                setState(() {
                  _flashCamera = !_flashCamera;
                });
                controller.toggleFlash();
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                print('Search');
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                      child:Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BottomModal(
                          products: _products,
                          addProduct: (addItem) {
                            setState(() {
                              item = addItem;
                            });
                          },
                        ),
                      )
                  )
                );
              }
            )
          ]
        ),
        body: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _isCameraMounted ? 1 : 0,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              child: Column(
                children: <Widget>[
                 Flexible(
                   flex: 2,
                   child: QRView(
                     key: qrKey,
                     onQRViewCreated: _onQRViewCreated,
                     overlay: QrScannerOverlayShape(
                       borderColor: Colors.red,
                       borderRadius: 10,
                       borderLength: 30,
                       borderWidth: 10,
                       cutOutSize: 300,
                     ),
                   ),
                 ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 10,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    showCursor: true,
                                    readOnly: true,
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
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _isScan = false;
                                            _scanItem.text = '';
                                            item = {};
                                            _orderCount = 1;
                                          });
                                        },
                                      ),
                                        hintText: 'Scan an item.'
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: false,
                                      signed: true,
                                    )
                                  )
                                ),
                                RaisedButton(
                                    child: Text('Add', style: TextStyle(color: Colors.white)),
                                    color: getColorFromHex(ColorSequence().collections[1]),
                                    onPressed: ()  {
                                      _addToCart();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                )
                              ],
                            )
                          ),
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
                                                    inputFormatters: [
                                                      new BlacklistingTextInputFormatter(new RegExp('[ -.,]'))
                                                    ],
                                                    textAlign: TextAlign.right,
                                                    onChanged: (val) {
                                                      if(int.parse(val) > item['pQuantity']) {
                                                        _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('The order exceed the remaining quantity.')));
                                                        return null;
                                                      } else {
                                                        setState(() {
                                                          _orderCount = val.length > 0 ? int.parse(val): 1;
                                                        });
                                                      }

                                                    },
                                                    decoration: InputDecoration(
                                                        hintText: '1',

                                                    ),
                                                    keyboardType: TextInputType.numberWithOptions(
                                                      decimal: false,
                                                      signed: false,
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
            if(_flashCamera) {
              setState(() {
                _flashCamera = false;
              });
              controller.toggleFlash();
            }
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (context, a1, a2) => ViewItems(
                loanActive: widget.loanActive,
                personalLoan: widget.personalLoan,
                localStorageProducts: _products,
                products: _soldItems,
                deleteItem: (String id) {
                  setState(() {
                    _soldItems.removeWhere((p) => p['pId'] == id);
                  });
                },
                updateItem: () {
                  setState(() {
                    _soldItems = [];
                  });
                  _fetchLocalStorage();
                },
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
      )
    );
  }
}
