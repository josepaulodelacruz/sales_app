import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Users.dart';
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

//components
import '../../components/TakePhoto.dart';

//models
import '../../models/Products.dart';

class AddItemState extends StatefulWidget {
  List products;
  Map<String, dynamic> editItem;
  int editIndex;
  Function updateProduct;
  List categories = [];

  AddItemState({Key key, this.products, this.editItem, this.editIndex, this.updateProduct, this.categories }) : super(key: key);

  @override
  createState () => _AddItemState();
}

class _AddItemState extends State<AddItemState> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List _products = [];
  String _imagePath;
  final _productName = TextEditingController();
  final _productCode = TextEditingController();
  String _productCategory = 'All';
  final _productPrice = TextEditingController();
  final _productQuantity = TextEditingController();
  final _productDescription = TextEditingController();
  String _productExpiration = new DateFormat.yMd().format(DateTime.now());
  String _productId;
  List _categories = [];
  final _newCategory = TextEditingController();
  String _status;

  @override
  void initState () {
    _fetchStatus();
    setState(() {
      _products = widget.products;
      _categories = widget.categories;
    });
    if(widget.editItem.isNotEmpty) {
      setState(() {
        _productName.text = widget.editItem['pName'];
        _productCode.text = widget.editItem['pCode'].toString();
        _productCategory = widget.editItem['pCategory'];
        _productPrice.text = widget.editItem['pPrice'].toString();
        _productQuantity.text = widget.editItem['pQuantity'].toString();
        _productDescription.text = widget.editItem['pDescription'];
        _productExpiration =  widget.editItem['pExpiration'];
        _productId = widget.editItem['pId'];
        _imagePath = widget.editItem['pImagePath'];
      });
    }
    super.initState();
  }

  _fetchStatus () async {
    await Users.userGetStatusPersistent().then((res) {
      print(res);
      setState(() {
        _status = res;
      });
    });
  }

  @override
  void _resetState () {
    setState(() {
      _productId = '';
      _productName.text = '';
      _productCode.text = '';
      _productCategory = 'All';
      _productPrice.text = '';
      _productQuantity.text = '';
      _productDescription.text = '';
      _productExpiration = new DateFormat.yMd().format(DateTime.now());
      _imagePath = null;
    });
  }

  @override
  Future<void> _saveToStorage (products) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final decode = json.encode(products);
    sharedPrefs.setString('ListProducts', decode).then((res) {
      _resetState();
    });
  }

  @override
  void _addProduct () {
    final Users userProvider = Provider.of<Users>(context, listen: false);
    final productInfo = Products.toJson(
        _productId,
        _productName.text,
        _productCode.text,
        _productCategory,
        _productPrice.text,
        _productQuantity.text,
        _productDescription.text,
        _productExpiration,
        _imagePath
    );

    if(productInfo['invalid']) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text(productInfo['error'])));
    } else {
      if (_status == 'trial') {
        if (_products.length >= 10) {
          print('your only in a trial version');
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent,
              content: new Text('This is only a trial version')));
          return null;
        } else {
          setState(() {
            _products.add(productInfo);
          });
          _saveToStorage(_products).then((res) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.greenAccent,
                content: new Text('Successfully added!')));
            widget.updateProduct();
            print('success');
          });
        }
      } else {
        print('paid');
        setState(() {
          _products.add(productInfo);
        });

        _saveToStorage(_products).then((res) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.greenAccent,
              content: new Text('Successfully added!')));
          widget.updateProduct();
          print('success');
        });
      }
    }

  }

  @override
  _editProduct (context) {
    final productInfo = Products.toJson(
        _productId,
        _productName.text,
        _productCode.text,
        _productCategory,
        _productPrice.text,
        _productQuantity.text,
        _productDescription.text,
        _productExpiration,
        _imagePath
    );

    if(productInfo['invalid']) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text(productInfo['error'])));
    } else {
      _products.map((product) {
        int index = _products.indexOf(product);
        if(product['pId'] == widget.editItem['pId'] ) {
          setState(() {
            _products[index] = productInfo;
          });
        }
      }).toList();

      _saveToStorage(_products).then((res) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.greenAccent, content: new Text('Successfully Edited!')));
        widget.updateProduct();
      }).then((res) {
        Navigator.pop(context);
      });

    }

  }

  @override
  void _addNewCategory (context) async {
    Map<String, dynamic> _categoryItem = await Categories.toJson(_newCategory.text);
    if(!_categoryItem['isValid']) {
      print('Something went wrong');
      return;
    } else {
      setState(() {
        _categories.add(_categoryItem);
      });
      Categories.saveCategoryToLocalStorage(_categories).then((res) {
        setState(() {
          _newCategory.text = '';
        });
      }).then((res) {
        widget.updateProduct();
        Navigator.pop(context);
      });
    }
  }

  @override
  void _newCategoryModal (context) async {
    return showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return WillPopScope(
            onWillPop: () {},
            child: Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                  opacity: a1.value,
                  child: AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            textCapitalization: TextCapitalization.words,
                                            controller: _newCategory,
                                            decoration: InputDecoration(
                                                labelText: 'Input new Category'
                                            ),
                                            validator: (value) {
                                              bool isExist = false;
                                              if(value.isEmpty) {
                                                return 'Please enter Category';
                                              }
                                              _categories.map((cc) {
                                                if(cc['cTitle'].toString().toLowerCase() == value.toLowerCase()) {
                                                  isExist = true;
                                                }
                                              }).toList();

                                              if(isExist) {
                                                return 'Category already Exist';
                                              }

                                              return null;

                                            },
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.clear, color: Colors.red),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.check, color: Colors.blue),
                                                onPressed: () {
                                                  if(_formKey.currentState.validate()) {
                                                    _addNewCategory(context);
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        )

                                      ],
                                    )
                                )
                            )
                          ],
                        )
                    ),
                  )
              ),
            )
        );

        },
        transitionDuration: Duration(milliseconds: 500),
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {}
    );
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
                     keyboardType: TextInputType.text,
                     textCapitalization: TextCapitalization.words,
                     decoration: InputDecoration(
                       labelText: 'Product Name'
                     )
                   ),
                   TextField(
                     inputFormatters: [
                       new BlacklistingTextInputFormatter(new RegExp('[ -.,]'))
                     ],
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
//                           print(result.type); // The result type (barcode, cancelled, failed)
//                           print(result.rawContent); // The barcode content
//                           print(result.format); // The barcode format (as enum)
//                           print(result.formatNote);
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
                   FocusScope.of(context).unfocus();
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
            items: _categories.map((val) {
              return new DropdownMenuItem<String>(
                value: val['cTitle'],
                child: Text(val['cTitle'].toString()),
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
              inputFormatters: [
                new BlacklistingTextInputFormatter(new RegExp('[ -,]'))
              ],
              controller: _productPrice,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: '0',
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
              inputFormatters: [
                new BlacklistingTextInputFormatter(new RegExp('[ -.,]'))
              ],
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
                FocusScope.of(context).unfocus();
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
      key: _scaffoldKey,
      backgroundColor: getColorFromHex('#f3f3f3'),
      appBar: AppBar(
        title: Text(widget.editItem.isEmpty ? 'Add item' : 'Edit item'),
        backgroundColor: getColorFromHex('#20BDFF'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Add category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            onPressed: () {
              _newCategoryModal(context);
            }
          )
        ],
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
              widget.editItem.isEmpty ? _addProduct() : _editProduct(context);
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
                  widget.editItem.isEmpty ? 'Add Item' : 'Edit Item',
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
