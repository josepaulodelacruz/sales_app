import 'package:flutter/material.dart';

class TabNavigator extends StatefulWidget {
  @override

  createState () => _TabNavigator();
}

class _TabNavigator extends State<TabNavigator> {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
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
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.dashboard,
                      ),
                      Text(
                        'Dashboard',
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
                        'Chats',
                        style: TextStyle(
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
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.dashboard,
                      ),
                      Text(
                        'Profile',
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
