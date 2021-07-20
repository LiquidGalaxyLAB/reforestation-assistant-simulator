import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CO2Chart extends StatefulWidget {
  final List<Seed> seeds;
  const CO2Chart(this.seeds);

  @override
  _CO2ChartState createState() => _CO2ChartState(this.seeds);
}

class _CO2ChartState extends State<CO2Chart> {
  late List<ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  final List<Seed> seeds;

  _CO2ChartState(this.seeds);

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<ChartData> getChartData() {
    final List<ChartData> chartData = [];
    seeds.forEach((element) {
      chartData.add(ChartData(element.commonName, element.co2PerYear));
    });

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCircularChart(
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (ChartData data, _) => data.label,
            yValueMapper: (ChartData data, _) => data.value,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
          )
        ],
      )
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}