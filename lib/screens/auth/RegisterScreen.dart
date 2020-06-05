import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';

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
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];
  CarouselController buttonCarouselController = CarouselController();
  List<String> personalInformation = ['Name', 'Address', 'Birthday', 'Age'];
  int _stepLevel = 1;
  Timer _timer;
  double fadeInCard = 50;

  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 200), () {
      setState(() {
        fadeInCard = 0;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  //currentStep
  void _currentStep(int step) {
    setState(() {
      _stepLevel = step;
    });

    buttonCarouselController.animateToPage(_stepLevel - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCirc);
  }

  @override
  Widget _logoContainer(context) {
    return Hero(
      tag: 'launch',
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              getColorFromHex('#00d2ff'),
              getColorFromHex('#3a7bd5')
            ],
            stops: [0.0, 0.9],
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)
          ),
        ),
      )
    );
  }

  @override
  Widget _buttonStepper (context) {
    Widget _divider (int index) {
      return Expanded(
        child: Container(
          child: Divider(
              thickness: 2,
              color: _stepLevel > index ? Colors.lightBlueAccent : Colors.black,
              height: 10
          )
        )
      );
    }


    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _currentStep(1),
            fillColor: _stepLevel >= 1 ? Colors.lightBlueAccent : Colors.white,
            child: Text('1', style: TextStyle(color: _stepLevel >= 1 ? Colors.white : Colors.black)),
            shape: CircleBorder(),
          ),
          _divider(1),
          RawMaterialButton(
            onPressed: () => _currentStep(2),
            elevation: 2.0,
            fillColor: _stepLevel >= 2 ? Colors.lightBlueAccent : Colors.white,
            child: Text('2', style: TextStyle(color: _stepLevel >= 2 ? Colors.white : Colors.black)),
            shape: CircleBorder(),
          ),
          _divider(2),
          RawMaterialButton(
            onPressed: () => _currentStep(3),
            elevation: 2.0,
            fillColor: _stepLevel >= 3 ? Colors.lightBlueAccent : Colors.white,
            child: Text('3', style: TextStyle(color: _stepLevel >= 3 ? Colors.white : Colors.black)),
            shape: CircleBorder(),
          ),
        ],
      )
    );
  }

  @override
  Widget _informationList (context) {
    CarouselController buttonCarousel = CarouselController();
    double _height = MediaQuery.of(context).size.height * 0.65;
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Container(
        height: _height,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            onPageChanged: (a, b) {
              setState(() {
                _stepLevel = a + 1;
              });
            },
            height: _height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
          ),
          items: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 25, left: 25),
              height: _height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: ListView(
                  children: personalInformation.map((info) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 32, vertical:15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(info.toString(), style: TextStyle(color: Colors.grey[500])),
                          TextFormField()
                        ],
                      )
                    );
                  }).toList(),
                )
              )
            ),
            Container(
              padding: const EdgeInsets.only(right: 25, left: 25),
              height: _height,
              width: MediaQuery.of(context).size.width,
              child: Card(child: Text('2'))
            ),
            Container(
                padding: const EdgeInsets.only(right: 25, left: 25),
                height: _height,
                width: MediaQuery.of(context).size.width,
                child: Card(child: Text('3'))
            ),
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex('#f3f3f3'),
      body: Stack(
        children: <Widget>[
          _logoContainer(context),
          _buttonStepper(context),
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: fadeInCard == 0 ? 1 : 0,
            child: AnimatedContainer(
              margin: EdgeInsets.only(top: fadeInCard),
              duration: Duration(milliseconds: 300),
              child: _informationList(context)

            )
          ),
        ],
      ),
    );
  }
}
