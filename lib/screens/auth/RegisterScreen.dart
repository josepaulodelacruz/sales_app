import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/MarkdownReader.dart';

import '../../utils/colorParser.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends StatefulWidget {
  @override
  createState () => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreenState> {
  String _activeInput;

  @override
  void initState () {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];

    Widget _forms = Container(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Personal Information',
            style: TextStyle(color: Colors.grey[500], fontSize: 22, fontWeight: FontWeight.w500),
          ),
          Divider(
            thickness: 2,
          ),
          Text(
            'Name',
            style: TextStyle(color: Colors.grey[500], height: 1.5, fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              elevation: _activeInput == 'Name' ? 10 : 1,
              child: TextField(
                onTap: () {
                  setState(() => _activeInput = 'Name');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Name.'
                ),
              )
            )
          ),
          Text(
            'Address',
            style: TextStyle(color: Colors.grey[500], height: 1.5, fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              elevation: _activeInput == 'Address' ? 10 : 1,
              child: TextField(
                onTap: () {
                  setState(() => _activeInput = 'Address');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.home),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Address.'
                ),
              )
            )
          ),
          Text(
            'Contact',
            style: TextStyle(color: Colors.grey[500], height: 1.5, fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              elevation: _activeInput == 'Contact' ? 10 : 1,
              child: TextField(
                onTap: () {
                  setState(() => _activeInput = 'Contact');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.contact_phone),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Contact.'
                ),
              )
            )
          ),
          Divider(
            thickness: 2,
          ),
          Text(
            'Account Information',
            style: TextStyle(color: Colors.grey[500], fontSize: 22, fontWeight: FontWeight.w500),
          ),
          Text(
            'Email',
            style: TextStyle(color: Colors.grey[500], height: 1.5, fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              elevation: _activeInput == 'Email' ? 10 : 1,
              child: TextField(
                onTap: () {
                  setState(() => _activeInput = 'Email');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Email.'
                ),
              )
            )
          ),
          Text(
            'Password',
            style: TextStyle(color: Colors.grey[500], height: 1.5, fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              elevation: _activeInput == 'Password' ? 10 : 1,
              child: TextField(
                onTap: () {
                  setState(() => _activeInput = 'Password');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Password.'
                ),
              )
            )
          ),
          Text(
            'Confirm Password',
            style: TextStyle(color: Colors.grey[500], height: 1.5, fontSize: 16, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              elevation: _activeInput == 'Confirm password' ? 10 : 1,
              child: TextField(
                onTap: () {
                  setState(() => _activeInput = 'Confirm password');
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Confirm password.'
                ),
              )
            )
          ),
          Divider(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MarkdownReader(typeTitle: 'Privacy Policy')
                    ));
                  },
                  child: Text(
                    'Privacy policy',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500
                    )
                  )
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MarkdownReader(typeTitle: 'Terms and Condition')
                    ));
                  },
                  child: Text(
                   'Terms and Condition',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500
                    )
                  )
                ),
              ],
            )
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              color: Colors.lightBlue,
              child: Text('Sign up', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )
          )
        ],
      )
    );

    // TODO: implement build
    return SafeArea(
      child: Scaffold(
       backgroundColor: getColorFromHex('#f3f3f3'),
       body: Container(
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Container(
                 height: MediaQuery.of(context).size.height * 0.30,
                 width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                   gradient: LinearGradient(
                     colors: [
                       getColorFromHex('#00d2ff'),
                       getColorFromHex('#3a7bd5'),
                     ],
                   ),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.5),
                       spreadRadius: 5,
                       blurRadius: 7,
                       offset: Offset(0, 3), // changes position of shadow
                     ),
                   ]
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     Flexible(
                       flex: 1,
                       child: IconButton(
                         onPressed: () {
                           Navigator.pop(context);
                         },
                         icon: Icon(Icons.arrow_back_ios, color: Colors.white)
                       ),
                     ),
                     Flexible(
                       flex: 2,
                       child: Container(
                         padding: EdgeInsets.only(left: 32),
                         child: Align(
                           alignment: Alignment.centerLeft,
                           child: Text('Create an\nAccount.', textAlign: TextAlign.start, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
                         ),
                       )
                     )
                   ],
                 )
               ),
               _forms


             ],
           )
         )

       )
      )
    );
  }

}
