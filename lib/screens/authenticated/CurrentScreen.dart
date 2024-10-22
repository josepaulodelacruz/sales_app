import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sari_sales/components/TabNavigator.dart';
import 'package:sari_sales/models/Users.dart';
import 'package:sari_sales/screens/authenticated/BarcodeScan.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class CurrentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurrentScreenState();
  }
}

class CurrentScreenState extends StatefulWidget {
  @override
  createState () => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreenState> {
  final _auth = FirebaseAuth.instance;
  Widget _activeWidget = HomeScreen();
  Timer _timer;
  bool _appearWidget = false;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];


  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _appearWidget = true;
      });
    });

    _fetchActiveSession();
    super.initState();
  }

  _fetchActiveSession () async {
    await Users.saveSession(true);
  }


  @override
  Widget _backgroundContainer() {
    return Hero(
      tag: 'background',
      child:  Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: _colors,
              stops: [0, 0.7]
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            return Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                title: Text('Do you want\nexit the application', textAlign: TextAlign.start, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[500] )),
                content: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No', style: TextStyle(color: Colors.grey[500]))
                      ),
                      FlatButton(
                        onPressed: () async {
                          await Users.saveSession(true);
                          exit(0);
                        },
                        child: Text('Yes', style: TextStyle(color: Colors.grey[500]))
                      ),
                    ],
                  )
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 100),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {}
        );
      },
      child: _appearWidget ? Scaffold(
        extendBody: true,
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Stack(
            children: <Widget>[
              _backgroundContainer(),
              Hero(
                  tag: 'login',
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  )
              ),
              AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _appearWidget ? 1 : 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(top: _appearWidget ? 0 : 50),
                    child: _activeWidget,
                  )
              )
            ],
          ),
        ),
        bottomNavigationBar: _appearWidget ? TabNavigator(currentWidget: (val) {
          setState(() {
            _activeWidget = val;
          });

        },
          isActiveWidget: _activeWidget.toString(),
        ) : null,
        floatingActionButton: _appearWidget ? FloatingActionButton(
          heroTag: 'barcode',
          onPressed: () {
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000),
              pageBuilder: (context, a1, a2) => BarcodeScan(),
            ));
          },
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: _colors
                ),
              ),
              child: Icon(Icons.camera),
          )
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ) : Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: _colors,
                  stops: [0, 0.7]
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/sarisalesLogo.png',
                  fit: BoxFit.contain,
                  height: 200,
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                        'Sari Sales\nApplication',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )
                    )
                ),
                Text('Track your inventory and Sales', style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.w300, fontSize: 18)),
                Text('Mobile Barcode', style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.w300, fontSize: 18)),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(backgroundColor: Colors.white),
                )
              ],
            )
        )
      )
    );
  }
}
