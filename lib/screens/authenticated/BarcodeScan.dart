import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

//component
import '../../components/ProductCard.dart';


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
  Timer _timer;
  bool _isCameraMounted = false;
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
    });
  }

  @override
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose () {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          color: Colors.blue,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Scan items'
                                  )
                                )
                              ),
                              FlatButton(
                                child: Icon(Icons.close, color: Colors.black),
                                onPressed: () => print('clear text'),
                              ),
                              RaisedButton(
                                  child: Text('Add'),
                                  onPressed: ()  {
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              )
                            ],
                          )
                        )
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
        elevation: 10,
        onPressed: () => print('pres'),
        child: Icon(Icons.shopping_cart, color: Colors.white)
      ),
    );
  }
}
