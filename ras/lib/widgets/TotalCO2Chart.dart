import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TotalCO2Chart extends StatefulWidget {
  final List<Seed> seeds;
  const TotalCO2Chart(this.seeds);

  @override
  _TotalCO2ChartState createState() => _TotalCO2ChartState(this.seeds);
}

class _TotalCO2ChartState extends State<TotalCO2Chart> {
  late List<LineChartData> _lineChartData;
  late TooltipBehavior _tooltipBehavior;
  final List<Seed> seeds;

  _TotalCO2ChartState(this.seeds);

  @override
  void initState() {
    _lineChartData = getLineChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  getCO2(int count) {
    double totalCO2 = 0;
    for(int i = 0; i < count; i++){
    seeds.forEach((element) {
      totalCO2 += element.co2PerYear;
    });
    }

    return totalCO2;
  }

    getYear(int count) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year);
    for(int i = 1; i < count; i++){
      date = new DateTime(now.year).add(Duration(days: 365));
    }
    return date.toString().substring(0,4);
  }

  List<LineChartData> getLineChartData() {
    final List<LineChartData> lineChartData = [
      LineChartData((getCO2(1)), '2022'),
      LineChartData((getCO2(2)), '2023'),
      LineChartData((getCO2(3)), '2024'),
      LineChartData((getCO2(4)), '2025'),
      LineChartData((getCO2(5)), '2026'),
      LineChartData((getCO2(6)), '2027'),
      LineChartData((getCO2(7)), '2028'),
      LineChartData((getCO2(8)), '2029'),
      LineChartData((getCO2(9)), '2030'),
      LineChartData((getCO2(10)), '2031'),
      LineChartData((getCO2(11)), '2032'),
    ];

    return lineChartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          LineSeries<LineChartData, String>(
            dataSource: _lineChartData,
            xValueMapper: (LineChartData data, _) => data.year,
            yValueMapper: (LineChartData data, _) => data.value,
          ),
        ],
        primaryXAxis: CategoryAxis(
          title: AxisTitle(
                text: 'Year',
                textStyle: TextStyle(color: Colors.blueGrey)),
          labelRotation: 45,
          labelStyle: TextStyle(color: Colors.blueGrey),
        ),
        primaryYAxis: NumericAxis(
            title: AxisTitle(
                text: 'CO2',
                textStyle: TextStyle(color: Colors.blueGrey)),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            visibleMaximum: getCO2(14)),
      ),
    );
  }
}

class LineChartData {
  final double value;
  final String year;

  LineChartData(this.value, this.year);
}
