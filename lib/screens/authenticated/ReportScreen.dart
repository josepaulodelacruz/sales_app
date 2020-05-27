import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:sari_sales/utils/colorParser.dart';

//components
import 'package:sari_sales/components/ProductChart.dart';

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
      isCard: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              getColorFromHex('#ff9966'),
              getColorFromHex('#ff5e62'),
            ],
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Sales Report', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400))
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('\$ 200.00', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_drop_up, color: Colors.white, size: 32)
                ],
              )
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('24 May, 2020', textAlign: TextAlign.end, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))
              ),
            )
          ],
        )
      ),
    ),
    Reports(
      cardTitle: 'Products',
      isCard: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                getColorFromHex('#56CCF2'),
                getColorFromHex('#2F80ED'),
              ],
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SparkBar(),
              )
            ],
          )
      ),
    ),
    Reports(
      cardTitle: 'Inventory',
      isCard: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: <Color>[
                getColorFromHex('#f85032'),
                getColorFromHex('#e73827'),
              ],
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SparkBar()
              )
            ],
          )
      ),
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
                opacity: isAnimate ? 0 : 1,
                child: AnimatedContainer(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  curve: Curves.easeOutExpo,
                  duration: Duration(milliseconds: 1000),
                  margin: EdgeInsets.only(top: isAnimate ? 50 : 0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    elevation: 10,
                    child: SizedBox(
                      height: expandedHeight,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: card.card,
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

