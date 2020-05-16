import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colorParser.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginScreenState();
  }
}

class LoginScreenState extends StatefulWidget {
  @override
  createState () => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenState> {
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];
  List<Map<String, dynamic>> _accountInfo = [
    { 'type': 'Username', 'value': '' },
    { 'type': 'Password', 'value': '' }
  ];


  @override
  Widget _iconBackBtn (BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      label: Text('Back', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget _textBanner (context) {

    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Hello There.', textAlign: TextAlign.start, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
          Text('Login or sign up to continue.', textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
        ],
      )
    );
  }

  @override
  Widget _loginForm (context) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.50,
          child: Container(
              height: 300,
              width: 300,
              child: Card(
                child: Form(
                  child: ListView.builder(
                    itemCount: _accountInfo.length,
                    itemBuilder: (context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: _accountInfo[index]['type'],
                                  labelStyle: TextStyle(color: Colors.grey[500])
                              ),
                            )
                          ],
                        )
                      );
                    },
                  )
                )
              )

          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
        Expanded(
          child: Hero(
            tag: 'launch',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: _colors,
                      stops: [0, 0.7]
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _iconBackBtn(context),
                    _textBanner(context),
                    _loginForm(context),
                  ],
                )
              )
            )
          )
        ]
      )
    );
  }
}
