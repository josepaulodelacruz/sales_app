import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Loans.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/providers/share_data.dart';
import 'package:sari_sales/utils/colorParser.dart';

class Shared extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: getColorFromHex('#f3f3f3'),
      appBar: AppBar(
        title: Text('Shared data'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white)
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<ShareData>(context).fetchData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            List _inventory = snapshot.data['inventory'];
            List _loans = snapshot.data['loans'];
            List _sales = snapshot.data['sales'];
            return  Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        snapshot.data['sender'] == null
                            ? Text('Sender: None', textAlign: TextAlign.start, style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.w500))
                            : Text('Sender: ${snapshot.data['sender']}', textAlign: TextAlign.start, style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                        snapshot.data['data_send'] == null
                            ? Text('${snapshot.data['date_send']}', textAlign: TextAlign.start, style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.w300))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        _sales.isNotEmpty ? NotificationCards(
                          title: 'Inventory',
                          itemCount: snapshot.data['inventory'].length,
                          typeIcon: Icon(Icons.table_chart, size: 42),
                          fetchCallBack: () {
                            return showDialog(
                              context: context,
                              builder: (context) => ConfirmationModal(
                                titleModal: 'Inventory',
                                applyData: () async {
                                  //default categories
                                  await Categories.saveCategoryToLocalStorage([{'cTitle': 'All', 'isValid': true}]);
                                  bool isSuccess = await ListProducts.fetchProductFromCloud(snapshot.data['inventory']);
                                  if(isSuccess) {
                                    _scaffoldKey.currentState.showSnackBar(new SnackBar( backgroundColor: Colors.greenAccent, content: new Text('Successfully updated!')));
                                    Navigator.pop(context);
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('Something went wrong please try again.')));
                                    Navigator.pop(context);
                                  }

                                }
                              )
                            );
                          },
                        ) : Card(child: ListTile(title: Text('No Fetch Invetory.'), subtitle: Text('Please try again'), trailing: Icon(Icons.warning))),
                        _loans.isNotEmpty ? NotificationCards(
                          title: 'Loans',
                          itemCount: snapshot.data['loans'].length,
                          typeIcon: Icon(Icons.credit_card, size: 42),
                          fetchCallBack: () {
                            return showDialog(
                              context: context,
                              builder: (context) => ConfirmationModal(
                                titleModal: 'Loans',
                                applyData: () async {
                                  await Loans.fetctLoansFromCloud(snapshot.data['loans']);
                                  Navigator.pop(context);
                                }
                              )
                            );
                          },
                        ) : Card(child: ListTile(title: Text('No Fetch Loans.'), subtitle: Text('Please try again'), trailing: Icon(Icons.warning))),
                        _inventory.isNotEmpty ? NotificationCards(
                          title: 'Sales',
                          itemCount: snapshot.data['sales'].length,
                          typeIcon: Icon(Icons.book, size: 42),
                          fetchCallBack: () {
                            return showDialog(
                              context: context,
                              builder: (context) => ConfirmationModal(
                                titleModal: 'Sales',
                                applyData: () async {
                                  await Transactions.fetchTransactionsFromCloud(snapshot.data['sales']);
                                  Navigator.pop(context);
                                }
                              )
                            );
                          },
                        ) : Card(child: ListTile(title: Text('No Fetch Transactions.'), subtitle: Text('Please try again'), trailing: Icon(Icons.warning))),
                      ],
                    )
                  )
                ],
              )
            );
          } else if(snapshot.hasError) {
            return Text('Unable to fetch');
          } else {
            return Center(
              child: CircularProgressIndicator()
            ) ;
          }
        },
      )
    );
  }
}

class NotificationCards extends StatelessWidget {
  String title;
  Icon typeIcon;
  int itemCount;
  final Function fetchCallBack;

  NotificationCards({this.title, this.fetchCallBack, this.typeIcon, this.itemCount = 0});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('total of ${itemCount}'),
        leading: typeIcon,
        trailing: IconButton(
          onPressed: fetchCallBack,
          icon: Icon(Icons.cloud_download),
        )
      )
    );
  }

}

class ConfirmationModal extends StatelessWidget {
  String titleModal;
  final Function applyData;

  ConfirmationModal({this.applyData, this.titleModal});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text('Download ${titleModal} data'),
      content: Text('If you download the data\nall your save ${titleModal} will\nbe overwritten.'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
        FlatButton(
          onPressed: applyData,
          child: Text('Yes'),
        ),
      ],
    );
  }
}

