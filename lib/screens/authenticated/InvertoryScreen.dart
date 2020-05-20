import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/constants/categoriesList.dart';
import 'package:sari_sales/screens/authenticated/AddItem.dart';
import '../../utils/colorParser.dart';

//components
import '../../components/ProductCard.dart';

class InventoryScreen extends StatefulWidget {

  @override
  createState () => _InventoryScreen();
}

class _InventoryScreen extends State<InventoryScreen> {
  Timer _timer;
  ScrollController _scrollController;
  bool _onMountAnimation = false;
  int _activeSortCategory;

  double _offsetScroll;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _onMountAnimation = true;
      });
    });
    print(_onMountAnimation);
    super.initState();
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
                    return AddItem();
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
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
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
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: categories.map((cc) {
                                  int sortIndex = categories.indexOf(cc);
                                  return AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: _onMountAnimation ? 1 : 0,
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 1000),
                                          curve: Curves.ease,
                                          padding: EdgeInsets.only(left: _onMountAnimation ? 0 : 100),
                                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                          child: RaisedButton(
                                              child: Text(cc),
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
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: 20,
                                    itemBuilder: (context, int index) {
                                      return AnimatedOpacity(
                                          duration: Duration(milliseconds: 500),
                                          opacity: _onMountAnimation ? 1 : 0,
                                          child: AnimatedContainer(
                                              duration: Duration(milliseconds: 1000),
                                              margin: EdgeInsets.only(top: _onMountAnimation ? 0 : 20),
                                              curve: Curves.ease,
                                              child: ProductCard()
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
