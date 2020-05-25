import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:sari_sales/constants/categoriesList.dart';
import 'package:sari_sales/screens/authenticated/AddItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colorParser.dart';

//components
import '../../components/ProductCard.dart';

//models
import '../../models/ListProducts.dart';
import '../../models/Categories.dart';
import '../../constants/colorsSequence.dart';

class InventoryScreen extends StatefulWidget {

  @override
  createState () => new _InventoryScreen();
}

class _InventoryScreen extends State<InventoryScreen> {
  Timer _timer;
  ScrollController _scrollController;
  bool _onMountAnimation = false;
  int _activeSortCategory;
  List _products = [];
  List _categories = [];

  double _offsetScroll;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _onMountAnimation = true;
      });
    });
    _fetchLocalStorage();
    _fetchCategoriesLocalStorage();
    super.initState();
  }

  _fetchLocalStorage () async {
    List _items = await ListProducts.getProductLocalStorage();
    setState(() {
      _products = _items;
    });
  }

  _fetchCategoriesLocalStorage () async {
    List fetchCategories = await Categories.getCategoryLocalStorage();
    setState(() {
      _categories = fetchCategories;
    });
  }

  void _deleteToLocalStorage (int index) async {
    setState(() {
      _products.removeAt(index);
    });
    //update local storage
    await ListProducts.saveProductToLocalStorage(_products);
  }

  Widget _textBanner (context) {
    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Inventory List', textAlign: TextAlign.start, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black38, shadows: _textShadow)),
            IconButton(
              icon: Icon(Icons.add, color: Colors.black38),
              onPressed: () {
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (context, a1, a2) {
                    return AddItemState(products: _products, editItem: {}, categories: _categories, updateProduct: () async {
                      await _fetchLocalStorage();
                    });
                  },
                ));
              },
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: _colors,
                stops: [0, 0.7]
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _textBanner(context),
              Expanded(
                flex: 1,
                child: Hero(
                  tag: 'addItem',
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),

                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 20, bottom: 15, right: 20, left: 20),
                              height: 60,
                              decoration: BoxDecoration(
                                  color: getColorFromHex('#f3f3f3'),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50.0),
                                      topRight: Radius.circular(50.0)
                                  )
                              ),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _categories.map((cc) {
                                  int sortIndex = _categories.indexOf(cc);
                                  return AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: _onMountAnimation ? 1 : 0,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.ease,
                                      padding: EdgeInsets.only(left: _onMountAnimation ? 0 : 100),
                                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                      child: RaisedButton(
                                        color: getColorFromHex(ColorSequence().collections[sortIndex % ColorSequence().collections.length]),
                                        child: Text(cc['cTitle'], style: TextStyle(color: Colors.white)),
                                        onPressed: ()  {
                                        },
                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                      )
                                    )
                                  );
                                }).toList(),
                              )
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 20, left: 20),
                              color: getColorFromHex('#f3f3f3'),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _products.length,
                                itemBuilder: (context, int index) {
                                  return AnimatedOpacity(
                                    key: ObjectKey(_products[index]),
                                    duration: Duration(milliseconds: 500),
                                    opacity: _onMountAnimation ? 1 : 0,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 1000),
                                      margin: EdgeInsets.only(top: _onMountAnimation ? 0 : 20),
                                      curve: Curves.ease,
                                      child: ProductCard(
                                        productInfo: _products[index],
                                        productIndex: index,
                                        isDelete: (del) {
                                          _deleteToLocalStorage(index);
                                        },
                                        isEdit: (int editIndex) {
                                          if(editIndex == index) {
                                            Navigator.push(context, PageRouteBuilder(
                                              pageBuilder: (context, a1, a2) => AddItemState(products: _products, editItem: _products[editIndex], editIndex: index, updateProduct: () async {
                                                await _fetchLocalStorage();
                                              }),
                                            ));
                                          }
                                        },
                                      )
                                    )
                                  );
                                },
                              )
                            )
                          )
                        ],
                      )
                  )
                )
              )
            ],
          )
        ),
      ],
    );
  }
}
