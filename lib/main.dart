import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//screens
import 'package:sari_sales/screens/LaunchScreen.dart';
import 'package:sari_sales/screens/RegisterScreen.dart';
import 'package:sari_sales/screens/LoginScreen.dart';
import 'package:sari_sales/screens/HomeScreen.dart';


void main() => runApp(MyApp(

));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sari Sales Application',
      initialRoute: '/',
      routes: {
        '/': (context) => LaunchScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      }
    );

  }
}
