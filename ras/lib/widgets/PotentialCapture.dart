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
  int yr = cur.year-1;
  for(int i = 0; i < count; i++){
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
                        primaryXAxis: NumericAxis(title: AxisTitle(text: 'Year',
                                textStyle: TextStyle(color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))),
                        primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto,title: AxisTitle(text: 'CO2 Capture (kg)',
                                textStyle: TextStyle(color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))),
                        legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,position: LegendPosition.bottom
                        ),
                        series: <ChartSeries>[
                          for (var i = 0; i < seeds.length; i++)
                            StackedAreaSeries<ChartData, int>(
                                name:seeds[i].commonName,
                                dataSource: [ChartData(getYear(0), getCO2(0, 1)), ChartData(getYear(1), getCO2(seeds[i].co2PerYear, 1)), ChartData(getYear(5), getCO2(seeds[i].co2PerYear, 5)),ChartData(getYear(10), getCO2(seeds[i].co2PerYear, 10)),ChartData(getYear(15), getCO2(seeds[i].co2PerYear, 15)),ChartData(getYear(20), getCO2(seeds[i].co2PerYear, 20)),ChartData(getYear(25), getCO2(seeds[i].co2PerYear, 25)),ChartData(getYear(30), getCO2(seeds[i].co2PerYear, 30)),ChartData(getYear(35), getCO2(seeds[i].co2PerYear, 35)),ChartData(getYear(40), getCO2(seeds[i].co2PerYear, 40)),],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                            ),
                        ]
                    ),
        );
    }
}

    class ChartData {
      ChartData(this.x, this.y);
      final int x;
      final double y;
    }