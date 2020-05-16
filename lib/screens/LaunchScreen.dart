import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../utils/colorParser.dart';

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

  Widget _logoContainer () {
    List<Color> _colors = [getColorFromHex('#48c6ef '), getColorFromHex('#6f86d6')];
    return Expanded(
      flex: 6,
      child: Hero(
        tag: 'launch',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _colors,
              stops: [0.0, 0.9],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)
            ),
          ),
          child: Center(
              child: Image.asset(
                'images/Hero.png',
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
            child: Text('Register'),
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
          RaisedButton(
            child: Text('Login')
          )
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
