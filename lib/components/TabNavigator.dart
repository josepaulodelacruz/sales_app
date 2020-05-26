import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/screens/authenticated/HomeScreen.dart';
import 'package:sari_sales/screens/authenticated/InvertoryScreen.dart';
import 'package:sari_sales/screens/authenticated/ReportScreen.dart';

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
      color: Colors.white,
      shape: CircularNotchedRectangle(),
//      color: getColorFromHex('#373234'),
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
                        color: widget.isActiveWidget == 'HomeScreen' ? Colors.lightBlueAccent : Colors.black
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: widget.isActiveWidget == 'HomeScreen' ? Colors.lightBlueAccent : Colors.black
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
                        color: widget.isActiveWidget == 'InventoryScreen' ? Colors.lightBlueAccent : Colors.black
                      ),
                      Text(
                        'Inventory',
                        style: TextStyle(
                          color: widget.isActiveWidget == 'InventoryScreen' ? Colors.lightBlueAccent : Colors.black
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
                      ),
                      Text(
                        'Reports',
                        style: TextStyle(
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.chat,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
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
