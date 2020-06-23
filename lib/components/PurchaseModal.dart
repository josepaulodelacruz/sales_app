import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';

class ConfirmPurchase extends StatefulWidget {
  @override
  _ConfirmPurchase createState () => _ConfirmPurchase();
}

class _ConfirmPurchase extends State<ConfirmPurchase>{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getColorFromHex('#00d2ff'),
                    getColorFromHex('#3a7bd5'),
                  ],
                ),
              ),
              child: Center(
                child: Text('Subscription', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    _textList(title: 'Unlimited Inventory Storage'),
                    _textList(title: 'Share your data to anyone'),
                    _textList(title: 'Save your data in the cloud'),
                    Text('For only: ₱129.00/month', style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                      height: 3,
                      fontWeight: FontWeight.w400
                    ))
                  ],
                )
              )
            ),
            Row(
              children: <Widget>[
                Flexible(
                    flex: 1,
                    child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                getColorFromHex('#FF416C'),
                                getColorFromHex('#FF4B2B'),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              )
                          ),
                        )
                    )
                ),
                Flexible(
                    flex: 1,
                    child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                getColorFromHex('#AAFFA9'),
                                getColorFromHex('#11FFBD'),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Text(
                                  'Yes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              )
                          ),
                        )
                    )
                )

              ],
            )
          ],
        )
      ),
    );
  }

  Container _textList ({title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w300
            )
          ),
          Icon(Icons.check, color: Colors.green, size: 32)
        ],
      )
    );
  }
}
