import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colorParser.dart';


import 'file:///D:/Projects/sari_sales/lib/screens/authenticated/CurrentScreen.dart';

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
  Timer _timer;
  bool cardOpacity = false;


  void initState () {
    // TODO: implement initState
    _timer = Timer(Duration(milliseconds: 1000), () {
      setState(() {
        cardOpacity = true;
      });
    });
    super.initState();
  }

  @override
  Widget _iconBackBtn (BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      label: Text('Back', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      onPressed: () {
        setState(() {
          cardOpacity = false;
        });
        Navigator.pop(context);
      },
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
      padding: const EdgeInsets.only(top: 10, left: 25),
      child:  Column(
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
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
             Container(
                margin: EdgeInsets.only(top: !cardOpacity ? 50 : 0),
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: 'login',
                      child: Card(
                          child: Form(
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 32),
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Username',
                                            labelStyle: TextStyle(color: Colors.grey[500])
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: TextStyle(color: Colors.grey[500])
                                        )
                                    ),
                                  ),
                                  FlatButton(
                                      child: Text('Forgot your password?', textAlign: TextAlign.start, style: TextStyle(color: Colors.grey[500]))
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: RaisedButton(
                                        onPressed: () {
                                        },
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
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
                                            "Sign in with Google?",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: RaisedButton(
                                        onPressed: () {
                                        },
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
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
                                            "Sign in with Facebook?",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              )
                          )
                      )
                    )
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.only(right: 50, left: 50),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context, PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 2000),
                      pageBuilder: (context, a1, a2) => CurrentScreen(),
                    ));
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            getColorFromHex('#a8ff78'),
                            getColorFromHex('#78ffd6'),
                          ],
                        )
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    ),
                  ),
                )
              ),
            ],
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Hero(
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
                )
              ),
              AnimatedOpacity(
                  duration: Duration(milliseconds: 600),
                  opacity: !cardOpacity ? 0 : 1,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 700),
                      margin: EdgeInsets.only(top: !cardOpacity ? 50 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _iconBackBtn(context),
                          _textBanner(context),
                          _loginForm(context)
                        ],
                      )
                  )
              )
            ],
          )
        )
      )
    );
  }
}
