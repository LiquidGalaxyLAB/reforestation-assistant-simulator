import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';
import 'package:ras/models/Project.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  getArea(ProjectViewArgs args){
    Project? p = args.project;
    List<LatLng> coord = p.geodata.areaPolygon.coord;
    coord.add(p.geodata.areaPolygon.coord[0]);
    double area = 0;
    if(coord.length > 2){
      for(int i = 0; i < coord.length - 1; i++){
          var p1 = coord[i];
          var p2 = coord[i+1];
          area += getRadians(p2.longitude-p1.longitude) * (2 + sin(getRadians(p1.latitude)) + sin(getRadians(p2.latitude)));
      }
      area = area * 6378137 * 6378137 / 2;
      area = area * 0.0001;//convert to hectares
    }
    return area.abs();
  }

  getRadians(double input){
      return input * pi / 180;
  }

  getTotal(int count){
    final args = ModalRoute.of(context)!.settings.arguments as ProjectViewArgs;
    double density = seeds[count].density ?? 0;
    double total = density * getArea(args);
    return total;
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
                                dataSource: [ChartData('Seeds Sown', (0.9 * getTotal(i)).ceilToDouble()), ChartData('Predation', 0.2 *(0.9 * getTotal(i))), ChartData('Hydric stress', 0.2 *(0.2 *(0.9 * getTotal(i)))), ChartData('Thermal stress', 0.5 * (0.2 *(0.2 *(0.9 * getTotal(i))))), ChartData('Bad location', 0.5 *(0.5 * (0.2 *(0.2 *(0.9 * getTotal(i)))))), ChartData('Establishment', 0.2 * (0.5 *(0.5 * (0.2 *(0.2 *(0.9 * getTotal(i))))))), ChartData('Survival', 0.11 * (0.2 * (0.5 *(0.5 * (0.2 *(0.2 *(0.9 * getTotal(i))))))))],
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