import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {

  @override
  createState () => _InventoryScreen();
}

class _InventoryScreen extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Inventory Screen')
      )
    );
  }
}
