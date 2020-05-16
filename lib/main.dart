import 'package:flutter/material.dart';

//screens
import 'package:sari_sales/screens/LaunchScreen.dart';
import 'package:sari_sales/screens/RegisterScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sari Sales Application',
      initialRoute: '/',
      routes: {
        '/': (context) => LaunchScreen(),
        '/register': (context) => RegisterScreen()
      },
    );

  }
}
