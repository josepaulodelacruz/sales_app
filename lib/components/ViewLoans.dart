import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/models/Loans.dart';
import 'package:sari_sales/screens/authenticated/BarcodeScan.dart';

import '../utils/colorParser.dart';

//models
import 'package:sari_sales/models/Transactions.dart';


class ViewLoans extends StatefulWidget {
  Map<String, dynamic >loanInfo;
  Function deleteLoan;

  ViewLoans({Key key, this.loanInfo, this.deleteLoan });

  @override
  createState () => _ViewLoans();
}

class _ViewLoans extends State<ViewLoans> {
  Map<String, dynamic> _loanInfo;
  List _loans;

  @override
  void initState() {
    setState(() {
      _loanInfo = widget.loanInfo;
      _loans = widget.loanInfo['loans'];
    });
    super.initState();
  }

  @override
  _deleteRow (index, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment verification'),
        contentPadding: EdgeInsets.only(top: 20),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('By confirming yes the\nloan record will be deleted.', textAlign: TextAlign.start, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[500] )),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                getColorFromHex('#DB3445'),
                                getColorFromHex('#FF0000'),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              )
                          ),
                        )
                      )
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          await Loans.deleteLoan(_loanInfo['id'], index).then((res) {
                            setState(() {
                              _loans.removeAt(index);
                            });
                          }).then((res) {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                getColorFromHex('#1FA2FF'),
                                getColorFromHex('#12D8FA'),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Yes',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                            )
                          ),
                        )
                      )
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    );

  }

  @override
  Widget build(BuildContext context) {
    List _prices = _loans.map((loan) => loan['orderCount'] * loan['pPrice']).toList();
    double _worthOfItems = _prices.fold(0, (previousValue, element) => previousValue + element);

    Widget _personInfo = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Hero(
              tag: 'viewLoan',
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(255, 148, 231, 225),
                child: CircleAvatar(
                  radius: 45,
                  child: Center(
                    child: ClipOval(
                      child: Image.file(
                        File(_loanInfo['imagePath']),
                        height: 85,
                        width: 100,
                        fit: BoxFit.fill,
                      )
                    ),
                  )
                ),
              ),
            )
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Personal Information.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black87)),
                  Text('${_loanInfo['first']} ${_loanInfo['last']}', style: TextStyle(height: 1.5)),
                  Text('${_loanInfo['address']}', style: TextStyle(height: 1.5)),
                  Text('${_loanInfo['contact']}', style: TextStyle(height: 1.5))
                ],
              )
            )
          ),
          Flexible(
            flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Worth', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black87)),
                    Text('P ${_worthOfItems}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Loan items ${_loanInfo['loans'].length.toString()}', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black87)),
                  ],
                )
              )
          )
        ],
      )
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorFromHex('#20BDFF'),
        title: Text('Loan information'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => BarcodeScan(
                  loanActive: true,
                  personalLoan: _loanInfo,
                )
              ));
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            color: getColorFromHex('#f3f3f3'),
            child: Column(
              children: <Widget>[
                _personInfo
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Product')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Date')),
                            ],
                            rows: _loans?.map((product) {
                              int index = _loans.indexOf(product);
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(product['pName'].toString()),
                                    onTap: () async {
                                      _deleteRow(index, context);
                                    }
                                  ),
                                  DataCell(Text(product['pPrice'].toString())),
                                  DataCell(Text(product['date'].toString())),
                                ]
                              );
                            })?.toList() ?? [],
                          )
                        )
                      ),
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

