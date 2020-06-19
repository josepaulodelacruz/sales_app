import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/providers/share_data.dart';
import 'package:sari_sales/utils/colorParser.dart';

class Shared extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: getColorFromHex('#f3f3f3'),
      appBar: AppBar(
        title: Text('Shared data')
      ),
      body: FutureBuilder(
        future: Provider.of<ShareData>(context).fetchData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Card(
                      child: ListTile(
                        title: Text('Inventory'),
                        subtitle: Text('total of'),
                        trailing: IconButton(
                          onPressed: (){
                            return showDialog(
                              context: context,
                              builder: (context) => ConfirmationModal(
                                applyData: () async {
                                  await ListProducts.saveProductToLocalStorage(snapshot.data['inventory']);
                                  Navigator.of(context).pop();
                                }
                              )
                            );
                          },
                          icon: Icon(Icons.cloud_download),
                        )
                      )
                    ),
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

class ConfirmationModal extends StatelessWidget {
  final Function applyData;

  ConfirmationModal({this.applyData});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text('Download inventory data'),
      content: Text('If you download the data\nall your save inventory will\nbe overwritten.'),
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

