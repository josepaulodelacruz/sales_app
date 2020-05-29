import 'dart:async';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';

import '../../utils/colorParser.dart';

//models
import '../../models/Transactions.dart';

class SalesTransactionTable extends StatefulWidget {
  @override
  createState () => _SalesTransactionTable();
}
class _SalesTransactionTable extends State<SalesTransactionTable>{
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];
  List _transactions;
  List _dates;
  bool _isLoading = true;

  @override
  void initState () {
    _fetchTransactionDetails();
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  _fetchTransactionDetails () async {
    await Transactions.getTransactionsDetails().then((res) {
      //sort all availables dates
      List d = res.map((d) => d['dates']).toList();
      List _sortedDates = d.toSet().toList();
      setState(() {
        _transactions = res;
        _dates = _sortedDates;
      });
    });
  }

  void _salesBy () {
    print(_dates.length);
    _dates.map((d) {
      print(d);
    }).toList();

  }


  @override
  Widget build(BuildContext context) {

    Widget _searchBar = Container(
      padding: EdgeInsets.only(top: 15),
      height: 70,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Card(
        elevation: 10,
        child: Align(
          alignment: Alignment.center,
          child:  TextField(
            decoration: InputDecoration(
              prefixIcon: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: '28 May 2020'),
          )
        )
      ),
    );

    Widget _transactionList = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _dates?.map((d) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(d.toString(), style: TextStyle(color: Colors.black38, fontSize: 20, fontWeight: FontWeight.w400)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Card(
                    child: Column(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: _transactions.map((transaction) {
                          return d == transaction['dates'] ? ListTile(
                            title: Text(transaction['productName'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            subtitle: Text('Purchased Item'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text('P ${transaction['amount']}', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                                Text('${transaction['quantity']}/pcs', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ) : SizedBox();
                        }).toList(),
                      ).toList(),
                    )
                  )
                )
              ],
            )
          );
        })?.toList() ?? [],
      )
    );

    return Scaffold(
      body: Stack(
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
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Align(
              alignment: Alignment.topCenter,
              child: _searchBar,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Profit Margin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('P 1,530', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Text('+5%', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20,
                    child: RaisedButton(
                      onPressed: () {
                        _salesBy();
                      },
                      child: Text('Daily', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      color: getColorFromHex('#36d1dc'),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                    )
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    child: RaisedButton(
                      onPressed: () {},
                      color: getColorFromHex('#ffb88c'),
                      child: Text('Weekly', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                    )
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    child: RaisedButton(
                      onPressed: () {},
                      color: getColorFromHex('#b06ab3'),
                      child: Text('Montly', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                    )
                  ),

                ],
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: getColorFromHex('#f3f3f3'),
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
                    child: ListView(
                      children: <Widget>[
                        _transactionList,
                      ],
                    )
                  )
                )

              ],

            )
          )
        ],
      )
    );
  }
}
