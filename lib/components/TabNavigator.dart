import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';
import 'package:sari_sales/screens/authenticated/InvertoryScreen.dart';
import 'package:sari_sales/screens/authenticated/ReportScreen.dart';
import 'package:sari_sales/screens/authenticated/SettingScreen.dart';

import '../utils/colorParser.dart';

class TabNavigator extends StatefulWidget {
  final isActiveWidget;
  Function currentWidget;

  TabNavigator({Key key, this.currentWidget, this.isActiveWidget }) : super(key: key);

  @override
  createState () => _TabNavigator();
}

class _TabNavigator extends State<TabNavigator> {

  @override
  Widget build(BuildContext context) {
    print(widget.isActiveWidget);
    return BottomAppBar(
//      color: Colors.white,
      shape: CircularNotchedRectangle(),
      color: getColorFromHex('#373234'),
      notchMargin: 10,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    widget.currentWidget(HomeScreen());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.dashboard,
                        color: widget.isActiveWidget == 'HomeScreen' ? Colors.yellow[300]: Colors.white
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: widget.isActiveWidget == 'HomeScreen' ? Colors.yellow[300]: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    widget.currentWidget(InventoryScreen());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.library_books,
                        color: widget.isActiveWidget == 'InventoryScreen' ? Colors.yellow[300] : Colors.white
                      ),
                      Text(
                        'Inventory',
                        style: TextStyle(
                          color: widget.isActiveWidget == 'InventoryScreen' ? Colors.yellow[300] : Colors.white
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            // Right Tab bar icons

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    widget.currentWidget(ReportScreen());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.pie_chart,
                        color: widget.isActiveWidget == 'ReportScreen' ? Colors.yellow[300] : Colors.white,
                      ),
                      Text(
                        'Reports',
                        style: TextStyle(
                          color: widget.isActiveWidget == 'ReportScreen' ? Colors.yellow[300] : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    widget.currentWidget(SettingScreen());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: widget.isActiveWidget == 'SettingScreen' ? Colors.yellow[300] : Colors.white,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: widget.isActiveWidget == 'SettingScreen' ? Colors.yellow[300] : Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
