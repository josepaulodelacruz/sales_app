import 'package:flutter/material.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Loans.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/models/Categories.dart';

class SettingConfirmationModal extends StatefulWidget {
  String typeReset;

  SettingConfirmationModal({Key key, this.typeReset });

  @override
  createState () => _SettingConfirmationModal();
}

class _SettingConfirmationModal extends State<SettingConfirmationModal> {


  Widget _showTypeModal(BuildContext context) {
    print(widget.typeReset);
    if(widget.typeReset == 'ProductReset') {
      return AlertDialog(
        title: Text('Reset Products'),
        content: Text('Are you sure you want to erase all the product records?', style: TextStyle(color: Colors.grey[500])),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            onPressed: () async {
              await ListProducts.resetProductInventory();
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      );
    } else if(widget.typeReset == 'ReportsReset') {
      return AlertDialog(
        title: Text('Reset Reports'),
        content: Text('Are you sure you want to erase all the record Reports?', style: TextStyle(color: Colors.grey[500])),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            onPressed: () async {
              await Transactions.resetTransactionDetails();
              Navigator.pop(context);
            },
            child: Text('Yes'),

          ),
        ],
      );
    } else if(widget.typeReset == 'CategoriesReset') {
      return AlertDialog(
        title: Text('Reset Categories'),
        content: Text('Are you sure you want to erase all the record Categories. It will include all the products recorded?', style: TextStyle(color: Colors.grey[500])),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            onPressed: () async {
              await Categories.resetCategories().then((res) async {
                ListProducts.resetProductInventory();
              });
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      );
    } else if(widget.typeReset == 'LoanReset') {
      return AlertDialog(
        title: Text('Reset Loans List'),
        content: Text('Are you sure you want to erase all the Loan records?', style: TextStyle(color: Colors.grey[500])),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            onPressed: () async {
              await Loans.resetLoanList();
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _showTypeModal(context);
  }
}
