import 'package:flutter/material.dart';
import 'package:flutter_demox/screens/example/resource/colors.dart';
import 'package:flutter_demox/screens/example/resource/styles.dart';

import 'radar_chart.dart';

class RadarView extends StatelessWidget {
  final int beautyEffectLevel;
  final int deepSleepLevel;
  final int shallowSleepLevel;
  final int obesityPreventionLevel;

  RadarView(
      {this.beautyEffectLevel = 0,
      this.deepSleepLevel = 0,
      this.shallowSleepLevel = 0,
      this.obesityPreventionLevel = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'resource.sleepCheckSleepRank',
            style: Styles.text6.merge(TextStyle(color: BeautyColors.gray01)),
          ),
          SizedBox(height: 8),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'resource.sleepCheckBeauty',
              style: Styles.text5.merge(TextStyle(color: BeautyColors.gray02)),
            ),
            SizedBox(width: 6),
            Text(
              beautyEffectLevel.toString(),
              style: Styles.text16.merge(TextStyle(
                  fontSize: 20, color: BeautyColors.pink01, height: 1)),
            )
          ]),
          Row(children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'resource.sleepCheckDeepSleepRank',
                style:
                    Styles.text5.merge(TextStyle(color: BeautyColors.gray02)),
              ),
              SizedBox(height: 6),
              Text(
                deepSleepLevel > -1 ? deepSleepLevel.toString() : 'resource.sleepCheckUnderscore',
                style: Styles.text16.merge(TextStyle(
                    fontSize: 20, color: BeautyColors.pink01, height: 1)),
              )
            ]),
            Container(
              padding: EdgeInsets.zero,
              width: 100,
              height: 100,
              child: RadarChart(
                values: [
                  beautyEffectLevel * 2.0,
                  shallowSleepLevel < 0 ? 0 : shallowSleepLevel * 2.0,
                  obesityPreventionLevel * 2.0,
                  deepSleepLevel < 0 ? 0 : deepSleepLevel * 2.0
                ],
                labels: ['', '', '', ''],
                maxValue: 10,
                fillColor: BeautyColors.pink03.withOpacity(0.3),
                strokeColor: BeautyColors.gray05,
                labelColor: BeautyColors.gray06,
                textScaleFactor: 0.12,
                maxLinesForLabels: 2,
                labelWidth: 50,
                chartRadiusFactor: 0.8,
                animate: false,
              ),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('resource.sleepCheckShallowSleepRank',
                  style: Styles.text5
                      .merge(TextStyle(color: BeautyColors.gray02))),
              SizedBox(height: 6),
              Text(shallowSleepLevel > -1 ? shallowSleepLevel.toString() : 'resource.sleepCheckUnderscore',
                  style: Styles.text16.merge(TextStyle(
                      fontSize: 20, color: BeautyColors.pink01, height: 1)))
            ]),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text('resource.sleepCheckFatRank',
                style:
                    Styles.text5.merge(TextStyle(color: BeautyColors.gray02))),
            SizedBox(width: 6),
            Text(obesityPreventionLevel.toString(),
                style: Styles.text16.merge(TextStyle(
                    fontSize: 20, color: BeautyColors.pink01, height: 1)))
          ]),
        ],
      ),
    );
  }
}
