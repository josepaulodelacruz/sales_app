import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Projects/sari_sales/lib/screens/auth/LoginScreen.dart';


import '../../utils/colorParser.dart';

class LaunchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LaunchScreenState();
  }
}

class LaunchScreenState extends StatefulWidget {

  @override
  createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreenState> {
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];
  double curvedEdge = 100.0;

  Widget _logoContainer () {
    return Expanded(
      flex: 6,
      child: Hero(
        tag: 'launch',
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _colors,
                stops: [0, 0.7]
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(MediaQuery.of(context).size.width, curvedEdge)
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
                Text('Mobile Barcode', style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.w300, fontSize: 18))
              ],
            )
          )
        )
      )
    );
  }

  Widget _launchButtons () {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.40,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      getColorFromHex('#00d2ff'),
                      getColorFromHex('#3a7bd5')
                    ],
                  )
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Register",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context, PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 1000),
                pageBuilder: (context, a1, a2) => LoginScreen(),
              ));
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.40,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      getColorFromHex('#00d2ff'),
                      getColorFromHex('#3a7bd5')
//                      Color.fromARGB(255, 148, 231, 225),
//                      Color.fromARGB(255, 62, 182, 226)
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                ),
              )
            ),

        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _logoContainer(),
          _launchButtons()
        ],
      )
    );
  }
}
