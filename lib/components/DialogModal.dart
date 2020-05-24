import 'package:flutter/material.dart';
import '../utils/colorParser.dart';

class DialogModal extends StatefulWidget {
  Function confirmTransaction;

  DialogModal({Key key, this.confirmTransaction}) : super(key: key);

  @override
  createState () => _DialogModal();
}

class _DialogModal extends State<DialogModal> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 20),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 0.50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Are you sure you want to \n proceed the transaction.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500]
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
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
                              getColorFromHex('#DB3445'),
                              getColorFromHex('#FF0000'),
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
                      onTap: () => widget.confirmTransaction(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              getColorFromHex('#1FA2FF'),
                              getColorFromHex('#12D8FA'),
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
            )

          ],
        )
      )
    );
  }
}

