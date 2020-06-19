import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sari_sales/models/Users.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/colorParser.dart';

import 'package:sari_sales/screens/authenticated/CurrentScreen.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _firestore = Firestore.instance;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];
  Timer _timer;
  String email;
  String password;
  bool cardOpacity = false;
  bool showSpinner = false;


  void initState () {
    // TODO: implement initState
    _timer = Timer(Duration(milliseconds: 1000), () {
      setState(() {
        cardOpacity = true;
      });
    });
    super.initState();
  }
//
//  Future signInWithGoogle(context) async {
//    final Users userProvider = Provider.of<Users>(context, listen: false);
//    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//    final GoogleSignInAuthentication googleSignInAuthentication =
//    await googleSignInAccount.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleSignInAuthentication.accessToken,
//      idToken: googleSignInAuthentication.idToken,
//    );
//
//    final AuthResult authResult = await _auth.signInWithCredential(credential);
//    final FirebaseUser user = authResult.user;
//
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
//
//    final FirebaseUser currentUser = await _auth.currentUser();
//    print('get user details');
//    print(user.providerData);
//    print(user.metadata);
//    print(currentUser.email);
//    print(currentUser.displayName);
//    print(currentUser.phoneNumber);
//    print(currentUser.providerId);
//    print(currentUser.uid);
//
//    userProvider.name = currentUser.displayName;
//    userProvider.address= 'Philippines';
//    userProvider.contact = currentUser.phoneNumber;
//    userProvider.email = currentUser.email;
//
//    _firestore.collection('users').document(currentUser.uid).setData({
//      'name': userProvider.name,
//      'address': userProvider.address,
//      'contact': userProvider.contact,
//      'status': 'trial',
//      'email': userProvider.email,
//    }).then((res) async {
//      //provider
//      await Users.userSaveStatusPersistent('trial');
//      await Users.saveUserInformation(userProvider.toJson());
//      userProvider.loginUser(userProvider.toJson());
//    });
//
//    assert(user.uid == currentUser.uid);
//
//    return 'signInWithGoogle succeeded: $user';
//  }
//
//  void signOutGoogle() async{
//    print('trying to sign out');
//    await googleSignIn.signOut();
//
//    print("User Sign Out");
//  }

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
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(color: Colors.grey[500])
                                      )
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          password = val;
                                        });
                                      },
                                      obscureText: true,
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
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: RaisedButton(
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
                                            style: TextStyle(color: Colors.white),
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
                  onPressed: () async {
                    final Users userProvider = Provider.of<Users>(context, listen: false);
                    try {
                      setState(() {
                        showSpinner = true;
                      });
                      final signUser = await _auth.signInWithEmailAndPassword(email: email, password: password);

                      if(signUser != null) {
                        final userId = await _auth.currentUser();
                        DocumentSnapshot querySnapshot = await Firestore.instance
                            .collection('users')
                            .document(userId.uid)
                            .get();

                        if (querySnapshot.exists) {
                          print('success');
                          userProvider.name = querySnapshot.data['name'];
                          userProvider.address = querySnapshot.data['address'];
                          userProvider.contact = querySnapshot.data['contact'];
                          userProvider.email = querySnapshot.data['email'];
                          userProvider.shortId = querySnapshot.data['shortId'];

                          await Users.saveUserInformation(userProvider.toJson());
                          await Users.userSaveStatusPersistent(querySnapshot.data['status']);
                          userProvider.loginUser(userProvider.toJson());
                        }

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

                        setState(() {
                          showSpinner = false;
                        });
                      }

                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('Something went wrong please try again.')));
                    }
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
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
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
      )
    );
  }
}
