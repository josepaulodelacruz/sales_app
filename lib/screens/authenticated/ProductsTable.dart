import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//utils
import 'package:sari_sales/utils/colorParser.dart';

//models
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Products.dart';



class ProductsTable extends StatefulWidget {
  List categories;
  List products;

  ProductsTable({Key key, this.categories, this.products});

  @override
  createState () => _ProductsTable();
}

class _ProductsTable extends State<ProductsTable> {
  List _categories;
  List _products;

  @override
  void initState () {
    setState(() {
      _categories = widget.categories;
      _products = widget.products;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _searchBar = Container(
      padding: EdgeInsets.only(top: 10),
      height: 70,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Card(
        elevation: 10,
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: 'Search Item'),
          )
        ),
    );

    Widget _tabViews = Container(
      child: TabBarView(
        children: _categories.map((cc) {
          List <dynamic> _productByCategory = cc['cTitle'] == 'All' ?
              _products.map((product) => product).toList() :
              _products.where((element) => element['pCategory'].contains(cc['cTitle'])).toList();

          List productName = _productByCategory.map((product) => product['pName']).toList();
          List productQuantity = _productByCategory.map((product) => product['pQuantity']).toList();
          List productPrice = _productByCategory.map((product) => product['pPrice']).toList();

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Quantity')),
                  ],
                  rows: _productByCategory.map((product) {
                    int index = _productByCategory.indexOf(product);
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(product['pName'].toString())),
                        DataCell(Text(product['pPrice'].toString())),
                        DataCell(Text(product['pQuantity'].toString())),
                      ]
                    );
                  }).toList(),
                )
              )
            ),
          );
        }).toList(),
      ),
    );


    return Hero(
      tag: 'table',
      child: DefaultTabController(
        length: _categories.length,
        child: Material(
          child: Scaffold(
            backgroundColor: getColorFromHex('#f3f3f3'),
            appBar: AppBar(
              bottom: TabBar(
                isScrollable: true,
                tabs: _categories == null ? [] : _categories.map((cc) {
                  return Tab(text: cc['cTitle']);
                }).toList(),
              ),
              title: Text('Products')
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: _searchBar,
                  ),
                  Expanded(
                   flex: 1,
                   child: _tabViews,
                  ),
                ],
              ),
            )
          ),
        )
      )
    );
  }

}
