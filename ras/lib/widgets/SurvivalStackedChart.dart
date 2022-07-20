import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SurvivalStackedChart extends StatefulWidget {
  final List<Seed> seeds;
  SurvivalStackedChart(this.seeds);
  @override
  _SurvivalStackedChartState createState() => _SurvivalStackedChartState(this.seeds);
}

class _SurvivalStackedChartState extends State<SurvivalStackedChart> {

  late List<ChartData> chartData;
  final List<Seed> seeds;
  _SurvivalStackedChartState(this.seeds);

  getTotal(int count){
    return seeds[count].density ?? 0;
  }

@override
    Widget build(BuildContext context) {
         return Container(
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(labelRotation: 45),
                        primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto,title: AxisTitle(text: 'Total Plants',
                                textStyle: TextStyle(color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))),
                        legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,position: LegendPosition.bottom
                        ),
                        series: <ChartSeries>[
                          for (var i = 0; i < seeds.length; i++)
                            StackedAreaSeries<ChartData, String>(
                                name:seeds[i].commonName,
                                dataSource: [ChartData('Seeds Sown', 0.9 * getTotal(i)), ChartData('Predation', 0.2 *(0.9 * getTotal(i))), ChartData('Hydric stress', 0.2 *(0.2 *(0.9 * getTotal(i)))), ChartData('Thermal stress', 0.5 * (0.2 *(0.2 *(0.9 * getTotal(i))))), ChartData('Bad location', 0.5 *(0.5 * (0.2 *(0.2 *(0.9 * getTotal(i)))))), ChartData('Establishment', 0.2 * (0.5 *(0.5 * (0.2 *(0.2 *(0.9 * getTotal(i))))))), ChartData('Survival', 0.11 * (0.2 * (0.5 *(0.5 * (0.2 *(0.2 *(0.9 * getTotal(i))))))))],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    showCumulativeValues: true,
                                    useSeriesColor: true
                                ),
                            ),
                        ]
                    )
        );
    }
}

    class ChartData {
      ChartData(this.x, this.y);
      final String x;
      final double y;
    }