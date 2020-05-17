import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/TabNavigator.dart';
import 'package:sari_sales/utils/colorParser.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreenState();
  }
}

class HomeScreenState extends StatefulWidget {
  @override
  createState () => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenState> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _backgroundContainer(),
            Hero(
              tag: 'login',
              child: Container(
                color: getColorFromHex('#f3f3f3'),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: _appearWidget ? TabNavigator() : null,
      floatingActionButton: _appearWidget ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
