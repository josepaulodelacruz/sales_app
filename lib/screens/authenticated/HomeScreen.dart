import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Home Screen')
      )
    );
  }
}
