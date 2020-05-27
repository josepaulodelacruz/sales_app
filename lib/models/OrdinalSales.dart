/// Spark Bar Example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color barColor;

  OrdinalSales({@required this.year, @required this.sales, @required this.barColor});
}
