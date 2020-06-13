import 'dart:async';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';

import '../../utils/colorParser.dart';
import '../../utils/dateTimeParse.dart';

//models
import '../../models/Transactions.dart';
import 'package:intl/intl.dart';

class SalesTransactionTable extends StatefulWidget {
  @override
  createState () => _SalesTransactionTable();
}
class _SalesTransactionTable extends State<SalesTransactionTable>{
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];
  List _transactions;
  List _dates;
  List _sortDates;
  int dateCalculation = 0;
  final _searchDate = TextEditingController();

  @override
  void initState () {

    _fetchTransactionDetails();
    super.initState();
  }

  @override
  _fetchTransactionDetails () async {
    await Transactions.getTransactionsDetails().then((res) {
      //sort all availables dates
      List d = res?.map((d) {
        return  d['dates'];
      })?.toList() ?? [];
      List _sortedDates = d.toSet().toList();
      List _toLatestDates = _sortedDates;
      //reverse the list of dates
      for(var i=0;i<_toLatestDates.length/2;i++){
        var temp = _toLatestDates[i];
        _toLatestDates[i] = _toLatestDates[_toLatestDates.length-1-i];
        _toLatestDates[_toLatestDates.length-1-i] = temp;
      }
      setState(() {
        _transactions = res;
        _dates = _sortedDates;
        _sortDates = _toLatestDates;
      });
    });
  }

  void _salesBy (int val) {
    setState(() {
      dateCalculation = val;
    });
  }

  void _fuzzySearch (val) {
    setState(() {
      _sortDates = val == '' ?
          _dates?.map((d) => d)?.toList() ?? [] :
          _dates.where((element) {
            return element.toString().toLowerCase().contains(_searchDate.text.toString().toLowerCase());
          }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(now);
//    DateTime parsedDate = parseDate(_sortDates[0]);
//    DateTime dateComputation = parsedDate.add(Duration(days: dateCalculation));

    String profitDate = 'Current Date';
    List _computeDates = [];
    List _transactionAmounts = _transactions?.map((transaction) {
      return transaction['dates'].toString().toLowerCase() == (_searchDate.text.toLowerCase() == '' ?
          formattedDate.toString().toLowerCase() :
          (_sortDates.isEmpty ? formattedDate.toString().toLowerCase() : _sortDates[0].toString().toLowerCase())) ?
          _computeDates.add(transaction) : 0;
    })?.toList() ?? [];

    List profitReport = _computeDates.isNotEmpty && _computeDates[0]['dates'] != formattedDate ? _transactions?.map((transaction) {
      DateTime pickDate = parseDate(_computeDates[0]['parseDates']);
      DateTime dateTransaction = parseDate(transaction['parseDates']);
      String stringDate = DateFormat.yMMMMd().format(pickDate);
      DateTime generateProfit = pickDate.add(Duration(days: dateCalculation));
      profitDate = DateFormat.yMMMMd().format(generateProfit);

//      print('${generateProfit} - ${dateTransaction} = ${generateProfit.isAfter(dateTransaction)}');

      if(generateProfit.isAfter(dateTransaction)) {
          return double.parse(transaction['amount']);
      } else {
        if(stringDate == transaction['dates']) {
          return double.parse(transaction['amount']);
        }
        return 0;
      }


    })?.toList() ?? [] : _computeDates?.map((dd) => double.parse(dd['amount']))?.toList() ?? [];
    print(profitReport);

    double _profitAmount = profitReport.fold(0, (i, j) => i + j);
    print(_profitAmount);

    Widget _searchBar () {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat.yMMMMd().format(now);
      return Container(
        padding: EdgeInsets.only(top: 15),
        height: 70,
        width: MediaQuery.of(context).size.width * 0.90,
        child: Card(
          elevation: 10,
          child: TextField(
            controller: _searchDate,
            onChanged: (val) => _fuzzySearch(val),
            decoration: InputDecoration(
              prefixIcon: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
              suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () {
                setState(() {
                  _searchDate.text = '';
                  _sortDates = _dates;
                });
              }),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Search date.'
            ),
          )
        )
      );
    }

    Widget _transactionList () {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _sortDates?.map((d) {
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
                          tiles: _transactions?.map((transaction) {
                            return d.toString() == transaction['dates'].toString() ? ListTile(
                              title: Text(transaction['productName'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                              subtitle: Text('Purchased Item'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('₱ ${transaction['amount']}', style: TextStyle(color: Colors.red[500], fontWeight: FontWeight.w700)),
                                  Text('${transaction['quantity']}/pcs', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ) : SizedBox();
                          })?.toList()?.reversed ?? [],
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
    }

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
              child: _searchBar(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Text('Profit Margin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  _computeDates.isNotEmpty && _computeDates[0]['dates'] != formattedDate ?
                    Text('${_computeDates[0]['dates']} - ${profitDate}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) :
                    Text('${formattedDate}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ],
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('₱ ${_profitAmount}', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
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
                        _salesBy(0);
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
                      onPressed: () {
                        _computeDates.isNotEmpty && _computeDates[0]['dates'] == formattedDate ? null : _salesBy(7);
                      },
                      color: _computeDates.isNotEmpty && _computeDates[0]['dates'] == formattedDate ? Colors.grey[500] : getColorFromHex('#ffb88c'),
                      child: Text('Weekly', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                    )
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    child: RaisedButton(
                      onPressed: () {
                        _computeDates.isNotEmpty && _computeDates[0]['dates'] == formattedDate ? null : _salesBy(30);
                      },
                      color: _computeDates.isNotEmpty && _computeDates[0]['dates'] == formattedDate ? Colors.grey[500] : getColorFromHex('#b06ab3'),
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
                        _transactionList(),
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
