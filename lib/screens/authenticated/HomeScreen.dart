import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List categories = [{'cTitle': 'All', 'cPath': '', 'isValid': true}];
  final _newCategory = TextEditingController();
  String _imageCategoryPath;
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
  }

  @override
  void _addNewCategory (context) async {
    Map<String, dynamic> _categoryItem = await Categories.toJson(_newCategory.text, _imageCategoryPath);
    if(!_categoryItem['isValid']) {
      print('Something went wrong');
      return;
    } else {
      setState(() {
        categories.add(_categoryItem);
      });
      Categories.saveCategoryToLocalStorage(categories).then((res) {
        setState(() {
          _imageCategoryPath = null;
          _newCategory.text = '';
        });
        print(res);
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
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            WidgetsFlutterBinding.ensureInitialized();

                            // Obtain a list of the available cameras on the device.
                            final cameras = await availableCameras();

                            // Get a specific camera from the list of available cameras.
                            final firstCamera = cameras.first;
                            Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, a1, a2) => TakePhoto(camera: firstCamera, isCapture: (path, pictureId) {
                                setState(() {
                                  _imageCategoryPath = path;
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  _newCategoryModal(context);
                                });

                              }),
                            ));
                          },
                          child: _imageCategoryPath == null ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: getColorFromHex('#373234'),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.camera_front, size: 32, color: Colors.white),
                                  ),
                                  Text('Add Pictrue', style: TextStyle(color: Colors.white))
                                ],
                              )
                          ) : Image.file(File(_imageCategoryPath))
                        )

                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                textCapitalization: TextCapitalization.words,
                                controller: _newCategory,
                                decoration: InputDecoration(
                                    labelText: 'Input new Category'
                                )
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
                                        _addNewCategory(context);
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
            icon: Icon(Icons.person),
          ),
          IconButton(
            icon: Icon(Icons.format_align_right),
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
              child: Text(_isCategoryActive.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black, shadows: _textShadow)),
            ),
            Text('Products', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black, shadows: _textShadow)),
          ],
        )
      )
    );

    Widget _searchBar = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search)
        )
      )
    );

    Widget _productCategory = Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cc) {
            int cardIndex = categories.indexOf(cc);
            return Transform.scale(
              scale: _isCategoryActive == cc['cTitle'] ? 0.95 : 1,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 150,
                width: 120,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _animateText = true;
                    });
                    _isAnimateText(cc['cTitle']);
                  },
                  child: Card(
                    color: _isCategoryActive == cc['cTitle'] ? Colors.yellowAccent : Colors.white,
                    elevation: _isCategoryActive == cc['cTitle'] ? 0 : 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(cc['cTitle'].toString(), style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),
                  )
                ),
              )
            );
          }).toList(),
        )
      )
    );

    Widget _productList = Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width  ,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Card(
              elevation: 10,
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
                          Text('1', style: TextStyle(color: Colors.white)),
                          Image.asset(
                            'images/Hero.png',
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Expiree date: 10/20/21', style: TextStyle(fontSize: 12, color: Colors.white)),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Product Name: Sample 1', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('ID: 1', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('Quantity: 12', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('Barcode: 203921', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
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


    return Stack(
      children: <Widget>[
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
          color: getColorFromHex('#f1f1f1'),
            borderRadius: BorderRadius.horizontal(
              right: Radius.elliptical(2000, 1000)
            )
          )
        ),
        Container(
          padding: EdgeInsets.only(top: 32),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                _topHeader,
                _topText,
                _searchBar,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Categories', textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold, shadows: _textShadow)),
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
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Products', textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold, shadows: _textShadow)),
                  ),
                ),
                _productList,
              ],
            )
          )
        )
      ],
    );
  }
}

