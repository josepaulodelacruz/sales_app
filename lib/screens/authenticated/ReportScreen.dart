import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';
class ReportScreen extends StatefulWidget {

  @override
  createState () => _ReportScreen();

}

class _ReportScreen extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {

    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];

    Widget _topButtons = Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              onPressed: () {},
              child: Container(
                decoration: new BoxDecoration(
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
              padding: EdgeInsets.all(0),
              onPressed: () {},
              child: Container(
                decoration: new BoxDecoration(
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
              padding: EdgeInsets.all(0),
              onPressed: () {},
              child: Container(
                decoration: new BoxDecoration(
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
            child: Text('Recent Activities', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold, shadows: _textShadow)),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(title: Text('testing ')),
                  ListTile(title: Text('testing ')),
                  ListTile(title: Text('testing ')),
                  ListTile(title: Text('testing ')),
                ],
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
              child: Text('App Features', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold, shadows: _textShadow)),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.90,
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(title: Text('testing ')),
                    ListTile(title: Text('testing ')),
                    ListTile(title: Text('testing ')),
                    ListTile(title: Text('testing ')),
                  ],
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
              delegate: MySliverAppBar(expandedHeight: 200),
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

  MySliverAppBar({@required this.expandedHeight});

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
        Positioned(
          top: expandedHeight / 3 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 10,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Center(
              child:  Card(
                elevation: 10,
                child: SizedBox(
                  height: expandedHeight,
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: FlutterLogo(),
                ),
              ),
            )
          ),
        ),
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
