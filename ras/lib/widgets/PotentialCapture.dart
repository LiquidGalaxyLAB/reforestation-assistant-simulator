import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PotentialCapture extends StatefulWidget {
  final List<Seed> seeds;
  PotentialCapture(this.seeds);
  @override
  _PotentialCaptureState createState() => _PotentialCaptureState();
}

class _PotentialCaptureState extends State<PotentialCapture> {

              final List<ChartData> chartData = <ChartData>[
            ChartData(2010, 10.53, 3.3, 2.2),
            ChartData(2011, 9.5, 5.4, 3.2),
            ChartData(2012, 10, 2.65, 8.2),
            ChartData(2013, 9.4, 2.62, 9.8),
            ChartData(2014, 5.8, 1.99, 7.3),
            ChartData(2015, 4.9, 1.44, 8.4),
            ChartData(2016, 4.5, 2, 1),
            ChartData(2017, 3.6, 1.56, 8.1),
            ChartData(2018, 3.43, 2.1, 9.0),
            ];

@override
    Widget build(BuildContext context) {
         return Container(
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom
                        ),
                        series: <ChartSeries>[
                            StackedAreaSeries<ChartData, int>(
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    useSeriesColor: true
                                ),
                                name:'species1',
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            ),
                            StackedAreaSeries<ChartData, int>(
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    useSeriesColor: true
                                ),
                                name:'species2',
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y1
                            ),
                            StackedAreaSeries<ChartData, int>(
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    useSeriesColor: true
                                ),
                                name:'species3',
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y2
                            ),
                        ]
                    )
        );
    }
}

    class ChartData {
      ChartData(this.x, this.y, this.y1, this.y2);
      final int x;
      final double y;
      final double y1;
      final double y2;
    }