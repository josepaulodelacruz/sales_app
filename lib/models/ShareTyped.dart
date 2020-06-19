import 'package:flutter/material.dart';


class ShareType {
  String title;
  String imageLogo;
  Alignment positionLogo;
  double sizeLogo;
  int saveItems;
  Widget child;

  ShareType({this.title, this.imageLogo, this.child, this.positionLogo, this.sizeLogo, this.saveItems});

}
