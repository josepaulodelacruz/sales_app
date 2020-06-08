import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sari_sales/components/DialogModal.dart';
import 'package:intl/intl.dart';

//constant
import '../../utils/colorParser.dart';

//models
import '../../models/ListProducts.dart';
import '../../models/Transactions.dart';
import '../../models/Loans.dart';

class ViewItems extends StatefulWidget {
  List products;
  List localStorageProducts;
  Function deleteItem;
  Function updateItem;
  bool loanActive;
  Map<String, dynamic> personalLoan;

  ViewItems({Key key, this.products, this.deleteItem, this.localStorageProducts, this.updateItem, this.loanActive, this.personalLoan }) : super(key: key);

  @override
  createState () => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _products = [];
  List _localStorageProducts = [];
  List _updatingProducts = [];
  List _transactions = [];
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
    _localStorageProducts = widget.localStorageProducts;

    super.initState();
  }

  //update products from local storage.
  @override
  void _transactionProcedure (context) async {
    List _total = _products.map((pp) => pp['pPrice'] * pp['orderCount']).toList();
    double computeTotal = _total.fold(0, (i, j) => i + j);
    double change = (_customerAmount.text == '' ? 0 : double.parse(_customerAmount.text)) - computeTotal;
    if(change.isNegative) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('Can\'t proccess transaction.')));
      Navigator.of(context).pop();
    } else {
      print('proceed transaction');
      _products.map((x) {
        _localStorageProducts.map((pp) {
          if (x['pId'] == pp['pId']) {
            int index = _localStorageProducts.indexOf(pp);
            setState(() {
              _localStorageProducts[index] = {
                ...pp,
                'pQuantity': (pp['pQuantity'] - x['orderCount']),
              };
            });
            //check if the quantity is less than 0 if is yes delete from the localstorage.
            if (_localStorageProducts[index]['pQuantity'] == 0 ||
                _localStorageProducts[index]['pQuantity'].isNegative) {
              setState(() {
                _localStorageProducts.removeAt(index);
              });
            }
          }
        }).toList();
      }).toList();

      ListProducts.saveProductToLocalStorage(_localStorageProducts).then((res) {
        widget.updateItem();
      });
      //check if the person who wants to loan
      if(widget.loanActive == true) {
        print('proceed to add loan');
        Loans.addItemLoan(_products, widget.personalLoan).then((res) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }

      Transactions.saveTransactionsDetails(_products).then((res) {
        setState(() {
          _products = [];
          _localStorageProducts = [];
        });
      });

      Navigator.pop(context);
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    print(_customerAmount.text);

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
      child: SingleChildScrollView(
        child: Card(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Price')),
            ],
            rows: _products.map((product) {
              int index = _products.indexOf(product);
              return DataRow(
                cells: [
                  DataCell(Text(product['pName'].toString()), onTap: () {
                    setState(() {
                      widget.deleteItem(product['pId']);
                    });
                  }),
                  DataCell(
                    TextField(
                    inputFormatters: [
                      new BlacklistingTextInputFormatter(new RegExp('[ -.,]'))
                    ],
                    onChanged: (val) {
                      if(int.parse(val) > _products[index]['pQuantity']) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('The order exceed the remaining quantity.')));
                        return null;
                      } else {
                        setState(() {
                          _products[index]['orderCount'] = int.parse(val);
                        });
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '${product['orderCount']}'
                    )
                  )),
                  DataCell(Text('P${_products[index]['pPrice'] * _products[index]['orderCount']}')),
                ]
              );
            }).toList(),
          )
        ),
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
              inputFormatters: [
                new BlacklistingTextInputFormatter(new RegExp('[ -.,]'))
              ],
              controller: _customerAmount,
              textAlign: TextAlign.right,
              onChanged: (val) {
//                setState(() {
//                  _customerAmount.text = val;
//                });
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
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: getColorFromHex('#20BDFF'),
            title: Text('Items List'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
        ),
        body: AnimatedOpacity(
          duration: Duration(milliseconds: 700),
          opacity: _onMountWidget ? 1 : 0,
          child: Container(
            child: Column(
              children: <Widget>[
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
                            child: DialogModal(
                              confirmTransaction: () {
                                _transactionProcedure(context);
                              }
                            )
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
