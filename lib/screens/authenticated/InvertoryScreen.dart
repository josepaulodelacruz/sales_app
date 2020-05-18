import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/constants/categoriesList.dart';
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
  int _activeSortCategory;
  double _offsetScroll;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 1999), () {
      print('trigger');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _textBanner () {

      List _textShadow = <Shadow>[
        Shadow(
          offset: Offset(10.0, 5.0),
          blurRadius: 8.0,
          color: Color.fromARGB(80, 0, 0, 255),
        ),
      ];

      return Container(
          margin: EdgeInsets.only(top: 50),
          padding: const EdgeInsets.only(top: 10, left: 55),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Inventory List', textAlign: TextAlign.start, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
            ],
          )
      );
    }

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
        _textBanner(),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
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
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(0.0),
                        child: AnimatedContainer(
                          height: MediaQuery.of(context).size.height,
                          width: 100,
                          duration: Duration(milliseconds: 300),
                          color: _activeSortCategory == sortIndex ? Colors.yellow : getColorFromHex('#20BDFF'),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.shopping_cart, color: _activeSortCategory == sortIndex ? Colors.white : Colors.black),
                              AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 500),
                                style: _activeSortCategory == sortIndex ?
                                TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold) :
                                TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
                                child: Text(cc),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _activeSortCategory = sortIndex;
                          });
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
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
                      return ProductCard();
                    },
                  )
                )
              )
            ],
          )
        )
      ],
    );
  }
}
