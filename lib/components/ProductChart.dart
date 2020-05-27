/// Spark Bar Example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/OrdinalSales.dart';

/// Example of a Spark Bar by hiding both axis, reducing the chart margins.
class SparkBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(),
      animate: true,

      /// Assign a custom style for the measure axis.
      ///
      /// The NoneRenderSpec only draws an axis line (and even that can be hidden
      /// with showAxisLine=false).
      primaryMeasureAxis:
      new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),

      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
      domainAxis: new charts.OrdinalAxisSpec(
        // Make sure that we draw the domain axis line.
          showAxisLine: true,
          // But don't draw anything else.
          renderSpec: new charts.NoneRenderSpec()),

      // With a spark chart we likely don't want large chart margins.
      // 1px is the smallest we can make each margin.
      layoutConfig: new charts.LayoutConfig(
          leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
          topMarginSpec: new charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec: new charts.MarginSpec.fixedPixel(0)),
    );
  }

  /// Create series list with single series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final globalSalesData = [
      new OrdinalSales(year: '2007', sales: 3100, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2008', sales: 4100, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2009', sales: 5400, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2010', sales: 2000, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2011', sales: 3500, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2012', sales: 6000, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2013', sales: 2100, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      new OrdinalSales(year: '2015', sales: 1100, barColor: charts.ColorUtil.fromDartColor(Colors.white)),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Global Revenue',
        data: globalSalesData,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.barColor,
      ),
    ];
  }
}
