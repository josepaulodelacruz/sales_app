import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/DialogModal.dart';

import '../../utils/colorParser.dart';

class ViewItems extends StatefulWidget {
  List products;
  Function deleteItem;

  ViewItems({Key key, this.products, this.deleteItem }) : super(key: key);

  @override
  createState () => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  List _products = [];
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

    _products = widget.products;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget _topHeader = Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Name', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold)),
          Text('Quantity', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold)),
          Text('Price', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold)),
        ],
      )
    );


    Widget _listProducts = Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, int index) {
            return Dismissible(
              key: Key(_products[index]['pId']),
              dismissThresholds: {
                DismissDirection.vertical: 0.4,
              },
              onDismissed: (direction) async {
                setState(() {
                  widget.deleteItem(_products[index]['pId']);
                });
              },
              // Show a red background as the item is swiped away.
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Icon(Icons.delete, color: Colors.white),
//                    Icon(Icons.delete, color: Colors.white),
//                  ],
//                )
              ),
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Text(_products[index]['pName'], style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              _products[index]['orderCount'] = int.parse(val);
                            });
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '${_products[index]['orderCount']}',
                          ),

                        )
//                        child: Text('${widget.products[index]['orderCount']}', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
                      ),
                      Flexible(
                        flex: 1,
                        child: Text('P${_products[index]['pPrice'] * _products[index]['orderCount']}', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold))
                      )
                    ],
                  )
                )
              )
            );
          },
        )
      )
    );

    Widget _totalComputation () {
      List _total = _products.map((pp) => pp['pPrice'] * pp['orderCount']).toList();
      double computeTotal = _total.fold(0, (i, j) => i + j);
      return Container(
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
                  child: Text('P ${computeTotal}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ),
            ],
          )
      );
    }


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
              onChanged: (val) {
                setState(() {
                  _customerAmount.text = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter Amount',
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

    Widget _change () {
      List _total = _products.map((pp) => pp['pPrice'] * pp['orderCount']).toList();
      double computeTotal = _total.fold(0, (i, j) => i + j);
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Text('Change is:', style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.10),
              Flexible(
                flex: 1,
                child: _customerAmount.text.length > 0 ? Text((double.parse(_customerAmount.text) - computeTotal).toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold) ) : Text('0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ),
            ],
          )
      );
    }


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
                  Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        _totalComputation(),
                        _amount,
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Divider(
                                  thickness: 5,
                                  color: Colors.grey[300],
                                  height: 36,
                                )
                            )
                        ),
                      ],
                    )
                  ),
                  _change(),
                  RaisedButton(
                    onPressed: () {
                      return showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                            child: Opacity(
                              opacity: a1.value,
                              child: DialogModal()
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {}
                      );
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
