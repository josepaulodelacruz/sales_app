import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//constant
//import '../../constants/categoriesList.dart';

//components
import '../../components/TakePhoto.dart';

//models
import '../../models/Categories.dart';


class HomeScreen extends StatefulWidget {
  @override
  createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> activeColor = [getColorFromHex('#AAFFA9'), getColorFromHex('#11FFBD')];
  List<Color> inActiveColor = [getColorFromHex('#ff9966'), getColorFromHex('#ff5e62'),];

  final _formKey = GlobalKey<FormState>();
  List categories;
  List _products;
  List _frequentlyBuy;
  final _newCategory = TextEditingController();
  String _isCategoryActive = 'All';
  bool _animateText = false;

  @override
  void initState () {
    _fetchCategoriesLocalStorate();
    super.initState();
  }

  _fetchCategoriesLocalStorate () async {
    await Categories.getCategoryLocalStorage().then((res) {
      setState(() {
        categories = res;
      });
    });
    await ListProducts.getProductLocalStorage().then((res) {
      setState(() {
        _products = res;
      });
    });
    await Transactions.frequentlyBought().then((res) {
      setState(() {
        _frequentlyBuy = res;
      });
    });
  }

  @override
  void _addNewCategory (context) async {
    Map<String, dynamic> _categoryItem = await Categories.toJson(_newCategory.text);
    if(!_categoryItem['isValid']) {
      print('Something went wrong');
      return;
    } else {
      setState(() {
        categories.add(_categoryItem);
      });
      Categories.saveCategoryToLocalStorage(categories).then((res) {
        setState(() {
          _newCategory.text = '';
        });
      }).then((res) {
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
                                    categories.map((cc) {
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

  //trigger animation text
  void _isAnimateText (category) {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _isCategoryActive = category;
        _animateText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];


    Widget _topHeader = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.format_align_right, color: Colors.white),
          ),
        ],
      )
    );

    Widget _topText = Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _animateText ? 0 : 1,
              child: Text(_isCategoryActive.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white, shadows: _textShadow)),
            ),
            Text('Products', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
          ],
        )
      )
    );

    Widget _searchBar = Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      margin: EdgeInsets.only(bottom: 30),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: 'Search',
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.search, color: Colors.white),
        )
      )
    );

    //frequently bought widget
    Widget _frequentlyBought = Container(
      width: MediaQuery.of(context).size.width,
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Frequently Bought', style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w500)),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _frequentlyBuy?.map((b) {
                int index = _frequentlyBuy.indexOf(b);
                return index   < 7 ? Container(
                    width: 80,
                    child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(b['imagePath']),
                          fit: BoxFit.contain,
                        )
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.09,
                        left: MediaQuery.of(context).size.width * 0.09,
                        child: Transform(
                          transform: new Matrix4.identity()..scale(0.7),
                          child: Chip(
                            backgroundColor: Colors.lightBlue,
                            label: Text('₱${b['price']}'),
                            labelStyle: TextStyle(fontSize: 12),
                          )
                        )
                      )
                    ],
                  )
                ) : SizedBox();
              })?.toList() ?? [],
            )
          )
        ],
      )
    );

    Widget _productCategory = Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories?.map((cc) {
            int cardIndex = categories.indexOf(cc);
            return AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.ease,
              padding: EdgeInsets.only(left: 0),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: _isCategoryActive == cc['cTitle'] ?
                RaisedButton(
                  color: getColorFromHex('#6DD5FA'),
                  onPressed: () {},
                  child: Text(cc['cTitle'], style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
                  : FlatButton(
                child: Text(cc['cTitle'], style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w700)),
                onPressed: ()  {
                  setState(() => _animateText = true);
                  _isAnimateText(cc['cTitle']);
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
              )

            );
          })?.toList() ?? [],
        )
      )
    );

//    Widget _sortProducts () {
//      List<dynamic> sortedProducts = _isCategoryActive == 'All' ?
//          _products?.map((product) => product)?.toList() ?? [] :
//          _products.where((element) => element['pCategory'].toString().contains(_isCategoryActive.toString())).toList();
//
//      return Container(
//        child: Column(
//          children: sortedProducts.map((product) {
//            int index = sortedProducts.indexOf(product);
//            return product['pQuantity'] <= 5 ? Container(
//              height: 165,
//              width: MediaQuery.of(context).size.width  ,
//              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//              child: Card(
//                elevation: 2,
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                        padding: EdgeInsets.all(0),
//                        color: getColorFromHex('#373234'),
//                        height: MediaQuery.of(context).size.height,
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
////                            Text('${index + 1}', style: TextStyle(color: Colors.white)),
//                            Image.file(
//                              File(product['pImagePath']),
//                              fit: BoxFit.fill,
//                            ),
////                            Text('${product['pExpiration']}', style: TextStyle(fontSize: 12, color: Colors.white)),
//                          ],
//                        )
//                      ),
//                    ),
//                    Expanded(
//                      flex: 2,
//                      child: Container(
//                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            Text('Product ${product['pName']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
//                            Text('Quantity: ${product['pQuantity']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
//                            Text('Barcode: ${product['pCode']}', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
//                          ],
//                        )
//                      )
//                    )
//                  ],
//                )
//              )
//            ) : SizedBox();
//          }).toList(),
//        ),
//      );
//    }

    Widget  _criticalProductList () {
      List<dynamic> sortedProducts = _isCategoryActive == 'All' ?
          _products?.map((product) => product)?.toList() ?? [] :
          _products.where((element) => element['pCategory'].toString().contains(_isCategoryActive.toString())).toList();
      return Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          children:  sortedProducts.map((product) {
            return product['pQuantity'] <= 5 ? Stack(
              children: <Widget>[
                Container(
                  color: getColorFromHex('#f3f3f3'),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('${product['pName']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black54)),
                        Text('${product['pExpiration']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey[500])),
                      ],
                    )
                  ),
                ),
                Positioned(
                  top: -10,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Image.file(
                      File(product['pImagePath']),
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.height * 0.20,
                      fit: BoxFit.cover,
                    ),
                ),
                Positioned  (
                  left: MediaQuery.of(context).size.width * 0.28,
                  child: Chip(
                    backgroundColor: Colors.red[500],
                    elevation: 5,
                    label: Text('Qty: ${product['pQuantity']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
                  )
                ),
                Positioned  (
                  top: MediaQuery.of(context).size.width * 0.25,
                  child: Chip(
                    backgroundColor: Colors.lightBlue,
                    elevation: 5,
                    label: Text('₱${product['pPrice']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
                  )
                )
              ],
            ) : SizedBox();
          }).toList(),
        )
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          color: getColorFromHex('#f3f3f3'),

          )
        ),
        SafeArea(
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      gradient: LinearGradient(
                        colors: [
                          getColorFromHex('#00d2ff'),
                          getColorFromHex('#3a7bd5'),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                        ]
                    ),
                    child: Column(
                      children: <Widget>[
                        _topHeader,
                        _topText,
                        _searchBar,
                      ],
                    )
                  ),
                  _frequentlyBought,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Categories', style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w500)),
                        Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child:  RaisedButton.icon(
                              color: getColorFromHex('#36d1dc'),
                              label: Text('New Category', style: TextStyle(fontSize: 11, color: Colors.white)),
                              icon: Icon(Icons.add, color: Colors.white, size: 18),
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              onPressed: () {
                                _newCategoryModal(context);
                              },
                            )
                        )
                      ],
                    ),
                  ),
                  _productCategory,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Critical Products', style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  _criticalProductList()
                ],
              )
            )
          )
        )
      ],
    );
  }
}

