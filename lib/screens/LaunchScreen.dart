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
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  Widget _logoContainer () {
    return Expanded(
      flex: 6,
      child: Hero(
        tag: 'launch',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _colors,
              stops: [0, 0.7]
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
                      Color.fromARGB(255, 148, 231, 225),
                      Color.fromARGB(255, 62, 182, 226)
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
              Navigator.pushNamed(context, '/login');
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.40,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      Color.fromARGB(255, 148, 231, 225),
                      Color.fromARGB(255, 62, 182, 226)
                    ],
                  )
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Login',
                textAlign: TextAlign.center,
              ),
            ),
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
