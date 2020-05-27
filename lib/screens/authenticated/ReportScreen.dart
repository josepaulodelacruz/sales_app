import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sari_sales/utils/colorParser.dart';

//models
import '../../models/Reports.dart';


class ReportScreen extends StatefulWidget {

  @override
  createState () => _ReportScreen();

}

class _ReportScreen extends State<ReportScreen> {
  String _showCard = 'Sales';
  bool _isAnimateCard = false;

  @override
  void _isCard(val) {
    setState(() {
      _showCard = val;
      _isAnimateCard = true;
    });

    Timer(Duration(milliseconds: 600), () {
      setState(() {
        _isAnimateCard = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _topButtons = Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              elevation: 15,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _isCard('Sales');
              },
              child: Container(
                  decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  gradient: new LinearGradient(
                    colors: [
                      getColorFromHex('#ff9966'),
                      getColorFromHex('#ff5e62'),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.add_shopping_cart, color: Colors.white),
                    Text('Sales Report', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                  ],
                )
              )
            )
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              elevation: 15,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _isCard('Products');
              },
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  gradient: new LinearGradient(
                    colors: [
                      getColorFromHex('#56CCF2'),
                      getColorFromHex('#2F80ED'),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.table_chart, color: Colors.white),
                    Text('Product Report', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                  ],
                )
              )
            )
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              elevation: 15,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _isCard('Inventory');
              },
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  gradient: new LinearGradient(
                    colors: <Color>[
                      getColorFromHex('#f85032'),
                      getColorFromHex('#e73827'),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.insert_chart, color: Colors.white),
                    Text('Inventory Report', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                  ],
                )
              )
            )
          ),
        ],
      )
    );

    Widget _recentTransaction = Container(
        padding: EdgeInsets.only(top: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text('Recent Activities', style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w400)),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.90,
              child: Card(
                child: Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        title: Text("Oreo", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Purchased item'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('29 May, 2020', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                            Text('P 120.00', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text("Coffee", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Purchased item'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('29 May, 2020', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                            Text('P 120.00', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text("Red Horse", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Purchased item'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('29 May, 2020', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                            Text('P 120.00', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text("Highlands Cornedbeef", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Purchased item'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('29 May, 2020', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                            Text('P 120.00', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ]
                  ).toList(),
                )
              )
            )
          ],
        )
    );

    Widget _loanList = Container(
        padding: EdgeInsets.only(top: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text('Lists', style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w400)),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.90,
              child: Card(
                child: Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      ListTile(
                        title: Text("Products", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Table'),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[500]),
                      ),
                      ListTile(
                        title: Text("Sales", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Table'),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[500]),
                      )
                    ],
                  ).toList(),
                )
              )
            )
          ],
        )
    );


    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                expandedHeight: 200,
                showCard: _showCard,
                isAnimate: _isAnimateCard,
              ),
              pinned: true,
              floating: false,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                color: getColorFromHex('#f3f3f3'),
                child: Column(
                  children: <Widget>[
                    _topButtons,
                    _recentTransaction,
                    _loanList,
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  String showCard;
  bool isAnimate = false;

  List<dynamic> cards = [
    Reports(
      cardTitle: 'Sales',
      isCard: Card(),
    ),
    Reports(
      cardTitle: 'Products',
      isCard: Card(),
    ),
    Reports(
      cardTitle: 'Inventory',
      isCard: Card(),
    ),
  ];


  MySliverAppBar({@required this.expandedHeight, this.showCard, this.isAnimate });

  @override
  Widget build( BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Image.asset(
          'images/gradien-bg.png',
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: 1,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
              child: Text(
                "Reports",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                ),
              ),
            )
          ),
        ),
        for(var card in cards ) card.title == showCard ? Positioned(
          top: expandedHeight / 3 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 10,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: !isAnimate ? 1 : 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  margin: EdgeInsets.only(top: isAnimate ? 25 : 0),
                  child: Card(
                    elevation: 10,
                    child: SizedBox(
                      height: expandedHeight,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Text(card.title.toString()),
                    ),
                  ),
                )
              )
            )
          ),
        ) : SizedBox(),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
