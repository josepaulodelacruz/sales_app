import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colorParser.dart';

class ViewItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _ViewItems();
  }
}

class _ViewItems extends StatefulWidget {

  @override
  createState () => _ViewItemsState();
}

class _ViewItemsState extends State<_ViewItems> {
  Timer _timer;
  bool _onMountWidget = false;
  final _customerAmount = TextEditingController();

  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _onMountWidget = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget _topHeader = Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Text('Product Name', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
          ),
          Flexible(
            flex: 1,
            child: Text('QTY', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
          ),
          Flexible(
            flex: 1,
            child: Text('Price', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
          )
        ],
      )
    );


    Widget _listProducts = Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, int index) {
            return ListTile(title: Text('test $index'));
          },
        )
      )
    );

    Widget _totalComputation = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Text('Total Price:', style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.10),
          Flexible(
            flex: 1,
            child:
            Text('P 32', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
          ),
        ],
      )
    );

    Widget _amount = Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            child: TextField(
              textAlign: TextAlign.right,
              controller: _customerAmount,
              decoration: InputDecoration(
                hintText: '32',
              ),
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
            )
          )

        ],
      )
    );

    return Hero(
      tag: 'soldItems',
      child: Scaffold(
          appBar: AppBar(
              title: Text('Items List')
          ),
          body: AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: _onMountWidget ? 1 : 0,
            child: Container(
              child: Column(
                children: <Widget>[
                  _topHeader,
                  _listProducts,
                  _totalComputation,
                  _amount,
                  RaisedButton(
                      onPressed: () {
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              getColorFromHex('#5AFF15'),
                              getColorFromHex('#00B712'),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                            child: Text(
                              'Checkout',
                              textAlign: TextAlign.center,
                            )
                        ),
                      )
                  ),
                ],
              )
            )
          )

      )
    );
  }
}
