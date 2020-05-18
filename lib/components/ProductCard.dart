import 'package:flutter/material.dart';
import '../constants/categoriesList.dart';
import '../utils/colorParser.dart';

class ProductCard extends StatefulWidget {
  @override
  createState () => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width  ,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: getColorFromHex('#373234'),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('1', style: TextStyle(color: Colors.white)),
                          Image.asset(
                            'images/Hero.png',
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text('Expiree date: 10/20/21', style: TextStyle(fontSize: 12, color: Colors.white)),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Product Name: Sample 1', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('ID: 1', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('Quantity: 12', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                          Text('Barcode: 203921', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                        ],
                      )
                    )
                  )
                ],
              )
            )
          ),
        ],
      )
    );
  }
}
