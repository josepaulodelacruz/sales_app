import 'package:flutter/material.dart';

class FirebaseBarcode extends StatefulWidget {
  @override
  createState () => _FirebaseBarcode();
}

class _FirebaseBarcode extends State<FirebaseBarcode>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Container(
        child: Center(
          child: Text('Barcode screen')
        )
      )
    );
  }
}
