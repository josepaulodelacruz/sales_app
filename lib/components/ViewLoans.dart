import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/screens/authenticated/BarcodeScan.dart';

import '../utils/colorParser.dart';


class ViewLoans extends StatefulWidget {

  Map<String, dynamic >loanInfo;

  ViewLoans({Key key, this.loanInfo }) : super(key: key);

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
  Widget build(BuildContext context) {

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
                        height: 90,
                        width: 90,
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
                    Text(_loanInfo['loans'].length.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Loan items', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black87)),
                  ],
                )
              )
          )
        ],
      )
    );

    return Scaffold(
      appBar: AppBar(
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
                                  DataCell(Text(product['pName'].toString())),
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

