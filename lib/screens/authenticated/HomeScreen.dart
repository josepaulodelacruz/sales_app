import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/models/Users.dart';
import 'package:sari_sales/screens/authenticated/ContactScreen.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' show join;
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

//constant
//import '../../constants/categoriesList.dart';

//components
import '../../components/TakePhoto.dart';
import '../../components/Search.dart';
//models
import '../../models/Categories.dart';


class HomeScreen extends StatefulWidget {
  @override
  createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  List<Color> activeColor = [getColorFromHex('#AAFFA9'), getColorFromHex('#11FFBD')];
  List<Color> inActiveColor = [getColorFromHex('#ff9966'), getColorFromHex('#ff5e62'),];
  final _formKey = GlobalKey<FormState>();
  List categories = [];
  List _products = [];
  List _frequentlyBuy = [];
  final _newCategory = TextEditingController();
  String _isCategoryActive = 'All';
  bool _animateText = false;
  String _storeImage;
  String _status;

  @override
  void initState () {
    _fetchCategoriesLocalStorate();
    super.initState();
  }

  _fetchCategoriesLocalStorate () async {
    List<Future> futures = [
      Categories.getCategoryLocalStorage(),
      ListProducts.getProductLocalStorage(),
      Transactions.frequentlyBought(),
      Users.getStorageImage(),
      Users.userGetStatusPersistent()
    ];
    List results = await Future.wait(futures);
    setState(() {
      categories = results[0];
      _products = results[1];
      _frequentlyBuy = results[2];
      _storeImage = results[3];
      _status = results[4];
    });
  }

  @override
  void _addNewCategory (context) async {
    Map<String, dynamic> _categoryItem = await Categories.toJson(_newCategory.text);
    if(!_categoryItem['isValid']) {
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
    final Users userProvider = Provider.of<Users>(context, listen: false);

    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];


    Widget _topHeader = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            }
          )
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

    Widget _searchBar = Hero(
        tag: 'search',
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        margin: EdgeInsets.only(bottom: 30),
        child: Material(
          color: Colors.transparent,
          child: TextFormField(
          showCursor: true,
          readOnly: true,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Search(
                products: _products,
                categories: categories,
              ),
            ));
          },
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
        ))
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
            _frequentlyBuy.length > 0 ? Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _frequentlyBuy?.map((b) {
                  int index = _frequentlyBuy.indexOf(b);
                  return index  < 7 ? Container(
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
                })?.toList() ?? [SizedBox()],
              )
            ) : Container(
              height: 100,
              child: Card(
                child: Center(
                  child: ListTile(
                    title: Text('No bought items', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    subtitle: Text('Please add items in the inventory.'),
                    trailing: Icon(Icons.warning),
                  )
                )
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

      Widget  _criticalProductList () {
        List<dynamic> sortedProducts = _isCategoryActive == 'All' ?
            _products?.map((product) => product)?.toList() ?? [] :
            _products.where((element) => element['pCategory'].toString().contains(_isCategoryActive.toString())).toList();

        List items = [];
        sortedProducts?.map((x) {
          if(x['pQuantity'] <= 5) {
            items.add(x);
            return;
          }
        })?.toList() ?? [];

        return items.length > 0 ? Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: items.map((product) {
              return Stack(
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
              );
            }).toList(),
          )
        ) : Container(
          height: 100,
          child: Card(
            child: Center(
              child: ListTile(
                title: Text('No Critical products', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                subtitle: Text('Products below less than 5 shall be indicated here.'),
                trailing: Icon(Icons.check),
              )
            )
          )
        );
      }

      return Scaffold(
          key: _drawerKey,
          extendBody: true,
          body: Stack(
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
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Hero(
                              tag: 'contacts',
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                elevation: 15,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ContactScreen(),
                                  ));
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(10),
                                    gradient: new LinearGradient(
                                      colors: [
                                        getColorFromHex('#00B4DB'),
                                        getColorFromHex('#0083B0'),
                                      ],
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Icon(Icons.contacts, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text('Contact Supplier', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                                    ],
                                  )
                                )
                              ),
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              elevation: 15,
                              padding: EdgeInsets.all(0),
                              child:  Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(10),
                                  gradient: new LinearGradient(
                                    colors: [
                                      getColorFromHex('#00B4DB'),
                                      getColorFromHex('#0083B0'),
                                    ],
                                  ),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(Icons.cloud_upload, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text('Share your Reports', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                                  ],
                                )
                              )
                            )
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
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: Users.getUserInformation(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return Container(
                color: getColorFromHex('#f3f3f3'),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'takePhoto',
                      child: Material(
                          child: _storeImage != null ? InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                WidgetsFlutterBinding.ensureInitialized();

                                // Obtain a list of the available cameras on the device.
                                final cameras = await availableCameras();

                                // Get a specific camera from the list of available cameras.
                                final firstCamera = cameras.first;
                                Navigator.push(context, PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 1),
                                  pageBuilder: (context, a1, a2) => TakePhoto(
                                    camera: firstCamera,
                                    isCapture: (path, picture) async {
                                      setState(() => _storeImage = path);
                                      await Users.saveStorageImage(path);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ));
                              },
                              child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.file(
                                      File(_storeImage),
                                      fit: BoxFit.fill
                                  )
                              )
                          ) : Container(
                              height: 200,
                              color: Colors.lightBlue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.add_a_photo, size: 42, color: Colors.white),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      WidgetsFlutterBinding.ensureInitialized();

                                      // Obtain a list of the available cameras on the device.
                                      final cameras = await availableCameras();

                                      // Get a specific camera from the list of available cameras.
                                      final firstCamera = cameras.first;
                                      Navigator.push(context, PageRouteBuilder(
                                        transitionDuration: Duration(seconds: 1),
                                        pageBuilder: (context, a1, a2) => TakePhoto(
                                          camera: firstCamera,
                                          isCapture: (path, picture) async {
                                            setState(() => _storeImage = path);
                                            await Users.saveStorageImage(path);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                                    },
                                  ),
                                  Text('Add photo of\nyour Store', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                                ],
                              )
                          )
                      )
                    ),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.lightBlue),
                      title: Text(snapshot.data['name'].toString(), style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.lightBlue),
                      title: Text(snapshot.data['email'].toString(), style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.lightBlue),
                      title: Text(snapshot.data['address'].toString(), style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_phone, color: Colors.lightBlue),
                      title: Text(snapshot.data['contact'].toString(), style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    ListTile(
                      leading: Icon(Icons.card_membership, color: Colors.lightBlue),
                      title: Text('Subscription: $_status', style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container()
                    ),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        onTap: () async {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () async {
                                    await _auth.signOut();
                                    await Users.saveSession(false);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                  },
                                ),
                              ],
                            )
                          );
                        },
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout', style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500)),
                      )
                    )
                  ],
                )
              );
            } else {
              return Text('Loading...');
            }
          },
        )
      )
    );
  }
}

