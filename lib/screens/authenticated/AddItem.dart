import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AddItemState();
  }
}

class AddItemState extends StatefulWidget {
  @override

  createState () => _AddItemState();
}

class _AddItemState extends State<AddItemState> {

  @override
  Widget build(BuildContext context) {

    Widget _itemForm = Container(
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget>[
           Flexible(
             flex: 2,
             child: Container(
               padding: EdgeInsets.all(32),
               child: Column(
                 children: <Widget>[
                   TextField(
                     decoration: InputDecoration(
                       labelText: 'Product Name'
                     )
                   ),
                   TextField(
                     decoration: InputDecoration(
                       labelText: 'Product Code'
                     )
                   )
                 ],
               )
             )
           ),
           Flexible(
             flex: 1,
             child: Container(
               height: MediaQuery.of(context).size.height * 0.20,
               width: MediaQuery.of(context).size.width * 0.35,
               margin: EdgeInsets.all(10),
               child: Card(
                 elevation: 10,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Icon(Icons.photo_camera),
                     Text('Add Picture')
                   ],
                 )
               )
             )
           )
         ],
       )
    );

    Widget _categoryInput = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Category', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          new DropdownButton<String>(
            value: 'All',
            items: <String>['All', 'Snacks', 'Noodles', 'Canned'].map((String val) {
              return new DropdownMenuItem<String>(
                value: val,
                child: Text(val)
              );
            }).toList(),
            onChanged: (_) {},
          )
        ],
      )
    );

    Widget _priceInput = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text('Price:', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          ),
          Flexible(
            flex: 2,
            child: TextField(
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: '32.00',
              )
            )
          )
        ],
      )
    );

    Widget _quantityInput = Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text('Quantity:', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
            ),
            Flexible(
                flex: 2,
                child: TextFormField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
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

    Widget _descInput = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Description:', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          TextField(
            decoration: InputDecoration(
              hintText: 'Input Description...',
              border: OutlineInputBorder()
            ),
            maxLines: 4,
          )
        ],
      )
    );

    Widget _expirationDate = Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text('Expiration Date:', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          ),
          Flexible(
            flex: 2,
            child:
            FlatButton(
              child: Text('05/21/20'),
              onPressed: () {
                return showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //which date will display when user open the picker
                    firstDate: DateTime(1950),
                    //what will be the previous supported year in picker
                    lastDate: DateTime
                        .now()) //what will be the up to supported date in picker
                    .then((pickedDate) {
                  //then usually do the future job
                  if (pickedDate == null) {
                    //if user tap cancel then this function will stop
                    return;
                  }
                });
              },
            )
          )

        ],
      )
    );

    return Scaffold(
      backgroundColor: getColorFromHex('#f3f3f3'),
      appBar: AppBar(
        title: Text('Add item')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ListView(
              children: <Widget>[
                _itemForm,
                _categoryInput,
                _priceInput,
                _quantityInput,
                _descInput,
                _expirationDate,
              ],
            )
          ),
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
                  'Add Item',
                  textAlign: TextAlign.center,
                )
              ),
            )
          ),
        ],
      )
    );
  }

}
