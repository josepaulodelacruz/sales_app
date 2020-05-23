import 'package:flutter/material.dart';

class ViewItems extends StatefulWidget {

  @override
  createState () => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Items List')
      ),
      body: Hero(
        tag: 'soldItems',
        child: Container(
          child: Center(
            child: Text('Sold Items'),
          )
        )
      )
    );
  }
}
