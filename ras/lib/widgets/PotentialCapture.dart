import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PotentialCapture extends StatefulWidget {
  final List<Seed> seeds;
  PotentialCapture(this.seeds);
  @override
  _PotentialCaptureState createState() => _PotentialCaptureState(this.seeds);
}

getYear(int count){
  DateTime cur = DateTime.now();
  int yr = cur.year;
  for(int i = 1; i < count; i++){
        yr = yr + 1;
  }
    return yr;
}

getCO2(double co2, int count){
  double result = co2;
  for(int i = 1; i < count; i++){
    result = result + co2;
  }
    return result;
}

class _PotentialCaptureState extends State<PotentialCapture> {

  late List<ChartData> chartData;
  final List<Seed> seeds;
  _PotentialCaptureState(this.seeds);

@override
    Widget build(BuildContext context) {
         return Container(
                    child: SfCartesianChart(
                        primaryXAxis: NumericAxis(),
                        primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
                        legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom
                        ),
                        series: <ChartSeries>[
                          for (var i = 0; i < seeds.length; i++)
                            StackedAreaSeries<ChartData, int>(
                                name:seeds[i].commonName,
                                dataSource: [ChartData(getYear(1), getCO2(seeds[i].co2PerYear, 1)), ChartData(getYear(2), getCO2(seeds[i].co2PerYear, 2)), ChartData(getYear(3), getCO2(seeds[i].co2PerYear, 3)), ChartData(getYear(4), getCO2(seeds[i].co2PerYear, 4)), ChartData(getYear(5), getCO2(seeds[i].co2PerYear, 5)), ChartData(getYear(6), getCO2(seeds[i].co2PerYear, 6)), ChartData(getYear(7), getCO2(seeds[i].co2PerYear, 7))],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                            ),
                        ]
                    )
        );
    }
}

    class ChartData {
      ChartData(this.x, this.y);
      final int x;
      final double y;
    }