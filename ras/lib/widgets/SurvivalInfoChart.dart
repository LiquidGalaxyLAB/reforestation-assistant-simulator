import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';

class SurvivalInfoChart extends StatefulWidget {
  final List<Seed> seeds;
  const SurvivalInfoChart(this.seeds);

  @override
  _SurvivalInfoChartState createState() => _SurvivalInfoChartState(this.seeds);
}

class _SurvivalInfoChartState extends State<SurvivalInfoChart> {
  late List<ChartData> _chartData;
  late List<LineChartData> _lineChartData;
  final List<Seed> seeds;

  _SurvivalInfoChartState(this.seeds);

  @override
  void initState() {
    _chartData = getChartData();
    _lineChartData = getLineChartData();
    super.initState();
  }

  getTotalItems() {
    double totalDensity = 0;
    seeds.forEach((element) {
      totalDensity += element.density ?? 0;
    });

    return totalDensity;
  }

  List<ChartData> getChartData() {
    final List<ChartData> chartData = [
      ChartData(
        'Germinative potential',
        (0.9 * getTotalItems()),
      ),
      ChartData(
        'Predation',
        (0.2 * (0.9 * getTotalItems())),
      ),
      ChartData(
        'Hydric stress',
        (0.2 * (0.2 * (0.9 * getTotalItems()))),
      ),
      ChartData(
        'Thermal stress',
        (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems())))),
      ),
      ChartData(
        'Bad location',
        (0.5 * (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems()))))),
      ),
      ChartData(
        'Establishment',
        (0.2 * (0.5 * (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems())))))),
      ),
      ChartData(
        'Survival',
        (0.11 *
            (0.2 * (0.5 * (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems()))))))),
      ),
    ];

    return chartData;
  }

  List<LineChartData> getLineChartData() {
    final List<LineChartData> lineChartData = [
      LineChartData((0.9 * getTotalItems()), 'Germinative potential'),
      LineChartData((0.2 * (0.9 * getTotalItems())), 'Predation'),
      LineChartData((0.2 * (0.2 * (0.9 * getTotalItems()))), 'Hydric stress'),
      LineChartData(
          (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems())))), 'Thermal stress'),
      LineChartData(
          (0.5 * (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems()))))), 'Bad location'),
      LineChartData(
          (0.2 * (0.5 * (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems())))))),
          'Establishment'),
      LineChartData(
          (0.11 *
              0.2 *
              (0.5 * (0.5 * (0.2 * (0.2 * (0.9 * getTotalItems())))))),
          'Survival'),
    ];

    return lineChartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        series: <ChartSeries>[
          ColumnSeries<ChartData, String>(
              dataLabelSettings: DataLabelSettings(isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
              dataSource: _chartData,
              xValueMapper: (ChartData e, _) => e.label,
              yValueMapper: (ChartData e, _) => e.value,
              color: Colors.green),
          LineSeries<LineChartData, String>(
            dataSource: _lineChartData,
            xValueMapper: (LineChartData e, _) => e.attr,
            yValueMapper: (LineChartData e, _) => e.value,
          ),
        ],
        primaryXAxis: CategoryAxis(
          labelRotation: 45,
          labelStyle: TextStyle(color: Colors.blueGrey),
        ),
        primaryYAxis: NumericAxis(
            title: AxisTitle(
                text: 'Total of seeds sown',
                textStyle: TextStyle(color: Colors.blueGrey)),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            visibleMaximum: getTotalItems()),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class LineChartData {
  final double value;
  final String attr;

  LineChartData(this.value, this.attr);
}
