import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/TabNavigator.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';
import 'package:sari_sales/utils/colorParser.dart';

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
    _timer = Timer(Duration(milliseconds: 2000), () {
      setState(() {
        _appearWidget = true;
      });
    });

    super.initState();
  }


  @override
  Widget _backgroundContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: _colors,
            stops: [0, 0.7]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _appearWidget = false;
        });
        Navigator.of(context).pop();
      },
      child: Scaffold(
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
              child: Icon(Icons.add)),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}
