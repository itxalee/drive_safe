import 'package:drive_safe/Screens/admin_screen/pie_chart/data/pie_data.dart';
import 'package:flutter/material.dart';

PieData pieData = PieData();

class IndicatorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: PieData.data
              .map(
                (data) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: buildIndicator(
                      color: data.color,
                      text: data.age,
                      // isSquare: true,
                    )),
              )
              .toList(),
        ),
      );

  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 12,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      );
}
