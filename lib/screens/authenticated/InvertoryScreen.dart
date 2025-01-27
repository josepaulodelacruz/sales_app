import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:sari_sales/constants/categoriesList.dart';
import 'package:sari_sales/screens/authenticated/AddItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colorParser.dart';

//components
import '../../components/ProductCard.dart';
import '../../components/Search.dart';

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
  bool _onMountAnimationCategory = false;
  bool _onMountAnimationCard = false;
  String _activeSortCategory = 'All';
  bool _triggerAnimation = false;
  List _products = [];
  List _categories = [];

  double _offsetScroll;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _onMountAnimationCategory = true;
        _onMountAnimationCard = true;
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

  void _deleteToLocalStorage (int index, del) async {
    setState(() {
      _products.removeWhere((element) => element['pId'] == del);
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
            Text('Inventory List', textAlign: TextAlign.start, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddItemState(products: _products, editItem: {}, categories: _categories, updateProduct: () async {
                      await _fetchLocalStorage();
                    });
                  }
                ));
//                Navigator.push(context, PageRouteBuilder(
//                  transitionDuration: Duration(seconds: 1),
//                  pageBuilder: (context, a1, a2) {
//                    return AddItemState(products: _products, editItem: {}, categories: _categories, updateProduct: () async {
//                      await _fetchLocalStorage();
//                    });
//                  },
//                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Search(
                    products: _products,
                    categories: _categories,
                  ),
                ));
              },
            )
          ],
        )
    );
  }

  @override
  Widget _listProducts (context) {
    List<dynamic> sortedProductList = _activeSortCategory == 'All' ? _products?.map((product) => product)?.toList() ?? [] : _products.where((element) => element['pCategory'].contains(_activeSortCategory)).toList();

    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        color: getColorFromHex('#f3f3f3'),
        child: _products.length > 0 ? ListView.builder(
          controller: _scrollController,
          itemCount: sortedProductList.length,
          itemBuilder: (context, int index) {
            return (sortedProductList[index]['pCategory'] == _activeSortCategory || _activeSortCategory == 'All') ? AnimatedOpacity(
              key: ObjectKey(sortedProductList[index]),
              duration: Duration(milliseconds: 1000),
              opacity: _onMountAnimationCard ? 1 : 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                margin: EdgeInsets.only(top: _onMountAnimationCard ? 0 : 20),
                curve: Curves.ease,
                child: ProductCard(
                  productInfo: sortedProductList[index],
                  productIndex: index,
                  isDelete: (del) {
                    _deleteToLocalStorage(index, del);
                  },
                  isEdit: (int editIndex) {
                    if(editIndex == index) {
                      Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, a1, a2) => AddItemState(products: _products, editItem: sortedProductList[editIndex], categories: _categories, editIndex: index, updateProduct: () async {
                          await _fetchLocalStorage();
                        }),
                      ));
                    }
                  },
                )
              )
            ) : null;
          },
        ) : Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
              'No items save',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                fontSize: 22,
              )
          )
        )
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
                colors: [
                  getColorFromHex('#00d2ff'),
                  getColorFromHex('#3a7bd5'),
                ],
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
                                color: getColorFromHex( '#f3f3f3'),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0)
                                )
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _categories?.map((cc) {
                                int sortIndex = _categories.indexOf(cc);
                                return AnimatedOpacity(
                                  duration: Duration(milliseconds: 1000),
                                  opacity: _onMountAnimationCategory ? 1 : 0,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 1000),
                                    curve: Curves.ease,
                                    padding: EdgeInsets.only(left: _onMountAnimationCategory ? 0 : 100),
                                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    child: RaisedButton(
                                      animationDuration: Duration(milliseconds: 2000),
                                      splashColor: Colors.white,
                                      color: getColorFromHex(ColorSequence().collections[sortIndex % ColorSequence().collections.length]),
                                      child: Text(cc['cTitle'], style: TextStyle(color: Colors.white)),
                                      onPressed: ()  {
                                        setState(() {
                                          _activeSortCategory = cc['cTitle'];
                                          _onMountAnimationCard = false;
                                        });
                                        //animate when sort by category change
                                        Timer(Duration(milliseconds: 500), () {
                                          setState(() {
                                            _onMountAnimationCard = true;
                                          });
                                        });
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                    )
                                  )
                                );
                              })?.toList() ?? [],
                            )
                          ),
                          _listProducts(context),
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
