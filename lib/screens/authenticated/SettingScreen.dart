import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  createState () => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Setting screen')
        )
      )
    );
  }
}
