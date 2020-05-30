import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/TabNavigator.dart';
import 'package:sari_sales/screens/authenticated/BarcodeScan.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';
import 'package:sari_sales/screens/authenticated/InvertoryScreen.dart';
import 'package:sari_sales/utils/colorParser.dart';
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
  Widget _activeWidget = HomeScreen();
  Timer _timer;
  bool _appearWidget = false;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];


  @override
  void initState () {
    _timer = Timer(Duration(milliseconds: 1000), () {
      setState(() {
        _appearWidget = true;
      });
    });

    super.initState();
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
                        onPressed: () {
                        },
                        child: Text('Yes', style: TextStyle(color: Colors.grey[500]))
                      ),
                    ],
                  )
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {}
        );
      },
      child: _appearWidget ? Scaffold(
        resizeToAvoidBottomPadding: true,
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
        body: Center(
          child: new SizedBox(
            height: 50.0,
            width: 50.0,
            child: new CircularProgressIndicator(
              value: null,
              strokeWidth: 7.0,
            ),
          )
        )
      )
    );
  }
}
