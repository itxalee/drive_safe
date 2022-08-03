// ignore_for_file: prefer_const_constructors

import 'package:drive_safe/Screens/admin_screen/pie_chart/data/pie_data.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

PieData pieData = PieData();
List<PieChartSectionData> getSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
      
      final value = PieChartSectionData(
        color: data.color,
        value: data.sleep,
        title: '${data.sleep}',
        showTitle: true,
        radius: 60,
        //radius: radius,
        titleStyle: TextStyle(
          //fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );

      return MapEntry(index, value);
    })
    .values
    .toList();
