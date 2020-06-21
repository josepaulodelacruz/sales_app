import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sari_sales/components/Shared.dart';
import 'package:sari_sales/models/ListProducts.dart';
import 'package:sari_sales/models/Loans.dart';
import 'package:sari_sales/models/Transactions.dart';
import 'package:sari_sales/providers/share_data.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//models
import 'package:sari_sales/models/ShareTyped.dart';

class ShareReports extends StatelessWidget {
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  @override
  Widget build(BuildContext context) {
    final shareData = Provider.of<ShareData>(context);
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: shareData.isError,
        child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  getColorFromHex('#00d2ff'),
                  getColorFromHex('#3a7bd5'),
                ],
                stops: [0, 0.7]
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        label: Text('Back', style: TextStyle(color: Colors.white)),
                      ),
                      FlatButton(
                        child: Badge(
                          toAnimate: true,
                          animationType: BadgeAnimationType.scale,
                          animationDuration: Duration(milliseconds: 300),
                          child: Text('Shared', style: TextStyle(color: Colors.white)),
                        ),
                        onPressed: ()  {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Shared(),
                          ));
                        },
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                      )
                    ],
                  )
                ),
                Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  controller: TextEditingController(text: shareData.id),
                  onChanged: (val) {
                    shareData.id = val;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'User ID',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.perm_identity, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                  )
                )),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Share your data to anyone', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: getColorFromHex('#f3f3f3'),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)
                )
              ),
            )
          ),
          ReportList()
        ],
      )
    )));
  }
}

class FetchRecords extends StatelessWidget{
  String titleType;

  FetchRecords({this.titleType});


  Widget buildType(BuildContext context) {
    final shareData = Provider.of<ShareData>(context);
    switch(titleType) {
      case 'sales':
        return FutureBuilder(
          future: Transactions.getTransactionsDetails(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Column(
                children: <Widget>[
                  Text(
                    'Upload all \n${snapshot.data.length} Transactions',
                    style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300, fontSize: 18),
                  ),
                  RaisedButton.icon(
                    color: Colors.greenAccent,
                    onPressed: ()  async {
                      shareData.isLoading();
                      Map<String, dynamic> isError = await shareData.shareTransactions(snapshot.data);
                      print(isError);
                      shareData.isLoading();
                      return showDialog(
                        context: context,
                        builder: (context) => IsDialog(isError: isError),
                      );
                    },
                    icon: Icon(Icons.cloud_upload, color: Colors.white),
                    label: Text('Share', style: TextStyle(color: Colors.white)),
                  )
                ],
              ));
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      case 'loans':
        return FutureBuilder(
          future: Loans.getLoanInformation(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data.length);
              return Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Upload List of \n${snapshot.data.length} Loan',
                      style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300, fontSize: 18),
                    ),
                    RaisedButton.icon(
                      color: Colors.greenAccent,
                      onPressed: ()  async {
                        shareData.isLoading();
                        Map<String, dynamic> isError = await shareData.shareLoans(snapshot.data);
                        shareData.isLoading();
                        return showDialog(
                          context: context,
                          builder: (context) => IsDialog(isError: isError)
                        );
                      },
                      icon: Icon(Icons.cloud_upload, color: Colors.white),
                      label: Text('Share', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ));
            } else {
              return CircularProgressIndicator();
            }
          }
        );
      case 'inventory':
        return FutureBuilder(
          future: ListProducts.getProductLocalStorage(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data.length);
              return Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Upload all \n${snapshot.data.length} Inventory',
                        style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300, fontSize: 18),
                      ),
                      RaisedButton.icon(
                        color: Colors.greenAccent,
                        onPressed: () async {
                          shareData.isLoading();
                          Map<String, dynamic> isError = await shareData.shareInventory(snapshot.data);
                          shareData.isLoading();
                          return showDialog(
                            context: context,
                            builder: (context) => IsDialog(isError: isError)
                          );
                        },
                        icon: Icon(Icons.cloud_upload, color: Colors.white),
                        label: Text('Share', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ));
            } else {
              return CircularProgressIndicator();
            }
          }
        );
      default:
        return Text('Hello world');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildType(context);
  }
}

class ReportList extends StatelessWidget{
  List<ShareType> _reports = [
    ShareType(title: 'sales', imageLogo: 'sales.png', child: FetchRecords(titleType: 'sales'), saveItems: 10, positionLogo: Alignment.topRight, sizeLogo: 0.18),
    ShareType(title: 'loans',imageLogo: 'list-icon.jpg', child: FetchRecords(titleType: 'loans'), saveItems: 20, positionLogo: Alignment.topRight, sizeLogo: 0.16),
    ShareType(title: 'inventory', imageLogo: 'inventory-1.png', child: FetchRecords(titleType: 'inventory'), saveItems: 30, positionLogo: Alignment.topRight, sizeLogo: 0.15),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView.builder(
          itemCount: _reports.length,
          itemBuilder: (context, int index) => Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 20, left: 20, top: 20),
                height: 150,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _reports[index].child,
                      ],
                    )
                  )
                )
              ),
              Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.10, top: MediaQuery.of(context).size.height * 0.01),
                child: Align(
                  alignment: _reports[index].positionLogo,
                  child: Image.asset(
                    'images/${_reports[index].imageLogo}',
                    height: MediaQuery.of(context).size.height * _reports[index].sizeLogo,
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}

class IsDialog extends StatelessWidget {
  Map<String, dynamic> isError;

  IsDialog({this.isError});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text('${isError['titleError']}'),
      content: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            !isError['error'] ? Icon(Icons.check, color: Colors.green, size: 40) : Icon(Icons.warning, size: 40, color: Colors.red[500]),
            SizedBox(width: 20),
            Text('${isError['message']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.grey[500]))
          ]
        )
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
          )
        )
      ],
    );
  }
}



