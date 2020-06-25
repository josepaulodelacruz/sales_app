import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sari_sales/providers/share_data.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

//screens
import 'package:sari_sales/screens/auth/LaunchScreen.dart';
import 'package:sari_sales/screens/auth/LoginScreen.dart';
import 'package:sari_sales/screens/auth/RegisterScreen.dart';
import 'package:sari_sales/screens/authenticated/CurrentScreen.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';


//models
import 'package:sari_sales/models/Users.dart';
import 'package:sari_sales/providers/contact_data.dart';
import 'package:sari_sales/providers/in_app_purchase.dart';
import 'package:sari_sales/services/AuthService.dart';

Future<void> main() {
  // For play billing library 2.0 on Android, it is mandatory to call
  // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
  // as part of initializing the app.
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Users>(
          create: (_) => Users(),
        ),
        ChangeNotifierProvider<ContactData>(
          create: (_) => ContactData(),
        ),
        ChangeNotifierProvider<ShareData>(
          create: (_) => ShareData(),
        ),
        ChangeNotifierProvider<InApp>(
          create: (_) => InApp(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: FutureBuilder(
          future: Users.getSession(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                  title: 'Sari Sales Application',
                  initialRoute: !snapshot.data['isLoggedIn'] ? '/' : '/home',
                  routes: {
                    '/': (context) => LaunchScreen(),
                    '/register': (context) => RegisterScreen(),
                    '/login': (context) => LoginScreen(),
                    '/home': (context) => CurrentScreen(),
                    '/dashboard': (context) => HomeScreen(),
                  }
              );
            } else {
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }
}
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MultiProvider(
//        providers: [
//          ChangeNotifierProvider<Users>(
//            create: (_) => Users(),
//          ),
//          ChangeNotifierProvider<ContactData>(
//            create: (_) => ContactData(),
//          ),
//          ChangeNotifierProvider<ShareData>(
//            create: (_) => ShareData(),
//          ),
//          ChangeNotifierProvider<InApp>(
//            create: (_) => InApp(),
//          ),
//          ChangeNotifierProvider<AuthService>(
//            create: (_) => AuthService(),
//          )
//        ],
//        child: MaterialApp(
//            title: 'Sari Sales Application',
//            initialRoute: '/',
//            routes: {
//              '/': (context) => LaunchScreen(),
//              '/register': (context) => RegisterScreen(),
//              '/login': (context) => LoginScreen(),
//              '/home': (context) => CurrentScreen(),
//              '/dashboard': (context) => HomeScreen(),
//            }
//        )
//    );
//  }
//}
