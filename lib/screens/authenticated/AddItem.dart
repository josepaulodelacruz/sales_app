import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../../components/TakePhoto.dart';


//models
import '../../models/Products.dart';

class AddItemState extends StatefulWidget {
  @override
  createState () => _AddItemState();
}

class _AddItemState extends State<AddItemState> {
  String _imagePath;
  final _productName = TextEditingController();
  final _productCode = TextEditingController();
  String _productCategory = 'All';
  final _productPrice = TextEditingController();
  final _productQuantity = TextEditingController();
  final _productDescription = TextEditingController();
  String _productExpiration = new DateFormat.yMd().format(DateTime.now());
  String _productId;

  @override
  void initState () {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void _addProduct () {
//    final productInfo = Products.toJson(_productName.text, _productCode.text, _productCategory, _productPrice.text, _productQuantity.text, _productDescription.text, _productExpiration);
//
//    print(productInfo);

  }

  @override
  Widget build(BuildContext context) {

    Widget _itemForm = Container(
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget>[
           Flexible(
             flex: 2,
             child: Container(
               padding: EdgeInsets.all(32),
               child: Column(
                 children: <Widget>[
                   TextField(
                     controller: _productName,
                     decoration: InputDecoration(
                       labelText: 'Product Name'
                     )
                   ),
                   TextField(
                     controller: _productCode,
                     onChanged: (val) {
                       setState(() {
                         _productCode.text;
                       });
                     },
                     decoration: InputDecoration(
                       labelText: 'Product Code',
                       suffixIcon: _productCode.text == '' ? IconButton(
                         icon: Icon(Icons.linked_camera),
                         onPressed: () async {
                           var result = await BarcodeScanner.scan();

                           FocusScope.of(context).unfocus();
                           print(result.type); // The result type (barcode, cancelled, failed)
                           print(result.rawContent); // The barcode content
                           print(result.format); // The barcode format (as enum)
                           print(result.formatNote);
                           setState(() {
                             _productCode.text = result.rawContent;
                           });
                         }
                       ) : IconButton(
                           icon: Icon(Icons.clear),
                           onPressed: () {
                               _productCode.text = '';
                             FocusScope.of(context).unfocus();
                           }
                       )
                     ),
                     keyboardType: TextInputType.numberWithOptions(
                       decimal: false,
                       signed: true,
                     ),
                   )
                 ],
               )
             )
           ),
           Flexible(
             flex: 1,
             child: Container(
                 height: MediaQuery.of(context).size.height * 0.20,
                 width: MediaQuery.of(context).size.width * 0.35,
                 margin: EdgeInsets.all(10),
                 child: InkWell(
                   onTap: () async {
                     WidgetsFlutterBinding.ensureInitialized();

                     // Obtain a list of the available cameras on the device.
                     final cameras = await availableCameras();

                     // Get a specific camera from the list of available cameras.
                     final firstCamera = cameras.first;
                     Navigator.push(context, PageRouteBuilder(
                       transitionDuration: Duration(seconds: 2),
                       pageBuilder: (context, a1, a2) => TakePhoto(camera: firstCamera, isCapture: (path, pictureId) {
                         setState(() {
                           _imagePath = path;
                           _productId = pictureId;
                         });
                         Navigator.pop(context);

                       }),
                     ));
                   },
                   child: _imagePath == null ? Hero(
                    tag: 'takePhoto',
                    child: Card(
                       elevation: 10,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.photo_camera),
                           Text('Add Picture')
                         ],
                       )
                    )
                   ) : Hero(tag: 'takePhoto', child: Image.file(File(_imagePath)))

               )
             )
           )
         ],
       )
    );

    Widget _categoryInput = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Category', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          new DropdownButton<String>(
            value: _productCategory,
            items: <String>['All', 'Snacks', 'Noodles', 'Canned'].map((String val) {
              return new DropdownMenuItem<String>(
                value: val,
                child: Text(val)
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _productCategory = val;
              });
            },
          )
        ],
      )
    );

    Widget _priceInput = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text('Price:', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          ),
          Flexible(
            flex: 2,
            child: TextField(
              controller: _productPrice,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: '32.00',
              ),
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
            )
          )
        ],
      )
    );

    Widget _quantityInput = Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text('Quantity:', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
            ),
            Flexible(
                flex: 2,
                child: TextFormField(
                  controller: _productQuantity,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                )
            )
          ],
        )
    );

    Widget _descInput = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Description:', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          TextField(
            controller: _productDescription,
            decoration: InputDecoration(
              hintText: 'Input Description...',
              border: OutlineInputBorder()
            ),
            maxLines: 4,
          )
        ],
      )
    );

    Widget _expirationDate = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text('Expiration Date:', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          ),
          Flexible(
            flex: 2,
            child:
            FlatButton(
              child: Text(_productExpiration, style: TextStyle(color: Colors.grey[500], fontSize: 18)),
              onPressed: () {
                return showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //which date will display when user open the picker
                    firstDate: DateTime(2015),
                    //what will be the previous supported year in picker

                    lastDate: DateTime(2050)).then((pickedDate) {
                    if (pickedDate == null) {
                      //if user tap cancel then this function will stop
                      return;
                    }
                    setState(() {
                      _productExpiration = new DateFormat.yMd().format(pickedDate);
                    });
                });
              },
            )
          )
        ],
      )
    );

    return Scaffold(
      backgroundColor: getColorFromHex('#f3f3f3'),
      appBar: AppBar(
        title: Text('Add item')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ListView(
              children: <Widget>[
                _itemForm,
                _categoryInput,
                _priceInput,
                _quantityInput,
                _descInput,
                _expirationDate,
              ],
            )
          ),
          RaisedButton(
            onPressed: () {
              _addProduct();
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    getColorFromHex('#5AFF15'),
                    getColorFromHex('#00B712'),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Add Item',
                  textAlign: TextAlign.center,
                )
              ),
            )
          ),
        ],
      )
    );
  }

}
