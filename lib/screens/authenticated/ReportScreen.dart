import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sari_sales/screens/authenticated/LoanList.dart';

import 'package:sari_sales/utils/colorParser.dart';

//screens
import 'package:sari_sales/screens/authenticated/ProductsTable.dart';
import 'package:sari_sales/screens/authenticated/SalesTransactionTable.dart';

//models
import '../../models/Reports.dart';
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Transactions.dart';


class ReportScreen extends StatefulWidget {

  @override
  createState () => _ReportScreen();

}

class _ReportScreen extends State<ReportScreen> {
  List _categories;
  List _products;
  List _transactions = [];
  String _showCard = 'Sales';
  bool _isAnimateCard = false;

  @override
  void initState () {
    _fetchLocalStorage();
    super.initState();
  }

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

  _fetchLocalStorage () async {
    List<Future> futures = [
      Categories.getCategoryLocalStorage(),
      ListProducts.getProductLocalStorage(),
      Transactions.getTransactionsDetails(),
    ];
    List results = await Future.wait(futures);
    setState(() {
      _categories = results[0];
      _products = results[1];
      if(results[2] != null) {
        var _toLatestDates = results[2];
        for(var i=0;i<_toLatestDates.length/2;i++){
          var temp = _toLatestDates[i];
          _toLatestDates[i] = _toLatestDates[_toLatestDates.length-1-i];
          _toLatestDates[_toLatestDates.length-1-i] = temp;
        }
        _transactions = _toLatestDates;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
    List _currentSales = [];
    List _currentTransactions = _transactions?.map((d) {
      if(d['dates'] == formattedDate) {
        _currentSales.add(d);
        return null;
      }
    })?.toList() ?? [];

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
            child: Text('Recent Transactions', style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w400)),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              child: _currentSales.length > 0 ? Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: _transactions?.map((transaction) {
                    int index = _transactions.indexOf(transaction);
                    return (4 >= index && transaction['dates'] == formattedDate.toString()) ? ListTile(
                      title: Text('${transaction['productName']}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      subtitle: Text('Purchased item'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(transaction['dates'].toString(), style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                          Text('₱ ${transaction['amount']}', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ) : SizedBox();
                  })?.toList() ?? [],
                ).toList(),
              ) : ListTile(
                  title: Text('No Transaction yet', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                  subtitle: Text('is recorded for this day.'),
                  trailing: Icon(Icons.warning),
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
                      Hero(
                        tag: 'table',
                        child: Material(
                          child: ListTile(
                            title: Text("Products", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            subtitle: Text('Table List'),
                            trailing: IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[500]), onPressed: () {
                              Navigator.push(context, PageRouteBuilder(
                                transitionDuration: Duration(seconds: 1),
                                pageBuilder: (context, a1, a2) => ProductsTable(categories: _categories, products: _products),
                              ));
                            }),
                          ),
                        )
                      ),
                      ListTile(
                        title: Text("Sales Transactions", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Table List'),
                        trailing: IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[500]), onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SalesTransactionTable(),
                          ));
                        }),
                      ),
                      ListTile(
                        title: Text("Listahan ng Utang", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        subtitle: Text('Loan information list'),
                        trailing: IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[500]), onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => LoanList(),
                          ));
                        }),
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
                currentDate: formattedDate.toString(),
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
  String currentDate;
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
            Text('Daily', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w500)),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: Reports.computeTransaction(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        return Text('₱${snapshot.data}', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  Icon(Icons.arrow_drop_up, color: Colors.white, size: 32)
                ],
              )
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('${Reports.isDate()}', textAlign: TextAlign.end, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))
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
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Product Report', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400))
                      ),
                    ),
                    Text('Total Items Sold', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                    Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FutureBuilder(
                              future: Transactions.totalItemSale(),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.done) {
                                  return Text('${snapshot.data} sold', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold));
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                            Icon(Icons.arrow_drop_up, color: Colors.white, size: 32)
                          ],
                        )
                    ),
                    Flexible(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text('${Reports.isDate()}', textAlign: TextAlign.end, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))
                      ),
                    )
                  ],
                )
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
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text('Inventory Report', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400))
                            ),
                          ),
                          Text('Remaining worth of', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                          Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FutureBuilder(
                                    future: ListProducts.remaningWorthOfItems(),
                                    builder: (context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.done) {
                                        return Text('₱ ${snapshot.data}', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold));
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  Icon(Icons.arrow_drop_up, color: Colors.white, size: 32)
                                ],
                              )
                          ),
                          Text('products', textAlign: TextAlign.end, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                          Flexible(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text('${Reports.isDate()}', textAlign: TextAlign.end, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))
                            ),
                          )
                        ],
                      )
                    )
                  ],
                )
              )
            ],
          )
      ),
    ),
  ];


  MySliverAppBar({@required this.expandedHeight, this.showCard, this.isAnimate, this.currentDate });

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

