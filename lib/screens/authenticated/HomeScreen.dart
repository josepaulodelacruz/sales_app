import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//      color: getColorFromHex('#373234'),

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
            Text('Food', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black, shadows: _textShadow)),
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
          children: <Widget>[
            Container(
              height: 150,
              width: 120,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Card(
                color: Colors.yellowAccent,
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.card_travel, size: 40),
                    Text('All', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black))
                  ],
                )
              )
            ),
            Container(
              height: 150,
              width: 120,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Card(
                color: null,
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.fastfood, size: 40),
                    Text('Snacks', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.black))
                  ],
                )
              )
            ),

          ],
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
          color: getColorFromHex('#E8E9EB'),
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
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Categories', textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold, shadows: _textShadow)),
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

