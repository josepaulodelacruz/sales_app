import 'package:flutter/material.dart';

class Reports {
  String title;
  Widget card;

  Reports({String cardTitle, Widget isCard}) {
    title = cardTitle;
    card = isCard;
  }

}
