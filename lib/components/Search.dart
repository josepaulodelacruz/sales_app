import 'package:flutter/material.dart';

import 'package:sari_sales/screens/authenticated/AddItem.dart';
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/models/ListProducts.dart';

class Search extends StatefulWidget {
  List products;
  List categories;

  Search({Key key, this.products, this.categories}) : super(key: key);

  @override
  createState () => _Search();
}

class _Search extends State<Search> {
  List _products;
  List _categories;
  List _sortedProducts;
  final _searchTerm = TextEditingController();

  @override
  void initState () {
    setState(() {
      _products = widget.products;
      _categories = widget.categories;
    });
    super.initState();
  }

  _fetchCategoriesLocalStorate () async {
    await Categories.getCategoryLocalStorage().then((res) {
      setState(() {
        _categories = res;
      });
    });
    await ListProducts.getProductLocalStorage().then((res) {
      setState(() {
        _products = res;
      });
    });
  }

  _fuzzySearch(String val) {
    setState(() {
      _sortedProducts = val == '' ?
        [] :
        _products.where((element) => element['pName'].toString().toLowerCase().contains(val.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.categories);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Hero(
            tag: 'search',
            child: Container(
            margin: EdgeInsets.all(10),
            child: Material(
              child: TextField(
                controller: _searchTerm,
                onChanged: (val) => _fuzzySearch(val),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search Item name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _sortedProducts = [];
                        _searchTerm.text = '';
                      });
                    },
                  )
                )
              )
            )
            )
          )
        ),
      ),
      body: Container(
        child: ListView(
          children: _sortedProducts?.map((product) {
            return Card(
              child: ListTile(
                title: Text(product['pName']),
                subtitle: Text(product['pCategory']),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddItemState(products: _products, editItem: product, categories: _categories, updateProduct: () async {
                        setState(() => _sortedProducts = []);
                        await _fetchCategoriesLocalStorate();
                      }),
                    ));
                  }
                ),
              )
            );
          })?.toList() ?? [Center(child: Text('No search result'))],
        )
      )
    );
  }
}
