import 'package:drive_safe/Screens/admin_screen/pie_chart/widget/indicators_widget.dart';
import 'package:drive_safe/Screens/admin_screen/pie_chart/widget/pie_chart_sections.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartPageState();
}

class PieChartPageState extends State {
  //var touchedIndex;

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  //pieTouchData: PieTouchData(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 5,
                  centerSpaceRadius: 80,
                  sections: getSections(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: IndicatorsWidget(),
                ),
              ],
            ),
          ],
        ),
      );
}
