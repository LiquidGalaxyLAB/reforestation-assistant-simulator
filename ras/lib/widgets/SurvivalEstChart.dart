import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';
import 'package:ras/models/Project.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ras/screens/ProjectView.dart';

class SurvivalEstChart extends StatefulWidget {
  final List<Seed> seeds;
  SurvivalEstChart(this.seeds);
  @override
  _SurvivalEstChartState createState() => _SurvivalEstChartState(this.seeds);
}

class _SurvivalEstChartState extends State<SurvivalEstChart> {

  late List<ChartData> chartData;
  final List<Seed> seeds;
  _SurvivalEstChartState(this.seeds);
  double pred = 80;
  double hydr = 80;
  double ther = 50;
  double badl = 50;
  double esta = 80;

  getArea(ProjectViewArgs args){
    Project? p = args.project;
    double area = 0;
    if(args.project.geodata != null){
    List<LatLng> coord = p.geodata.areaPolygon.coord;
    if(coord.isNotEmpty){
    coord.add(p.geodata.areaPolygon.coord[0]);
    if(coord.length > 2){
      for(int i = 0; i < coord.length - 1; i++){
          var p1 = coord[i];
          var p2 = coord[i+1];
          area += getRadians(p2.longitude-p1.longitude) * (2 + sin(getRadians(p1.latitude)) + sin(getRadians(p2.latitude)));
      }
      area = area * 6378137 * 6378137 / 2;
      area = area * 0.0001;//convert to hectares
    }
    }
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
    return total.ceil();
  }

@override
    Widget build(BuildContext context) {
         return Container(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [ SfCartesianChart(
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
                                dataSource: [ChartData('Initial', 1.0 * getTotal(i)), ChartData('Seeds Sown', 0.9 * getTotal(i)), ChartData('Predation', (100-pred)/100 *(0.9 * getTotal(i))), ChartData('Hydric stress', (100-hydr)/100 *((100-pred)/100 *(0.9 * getTotal(i)))), ChartData('Thermal stress', (100-ther)/100 * ((100-hydr)/100 *((100-pred)/100 *(0.9 * getTotal(i))))), ChartData('Bad location', (100-badl)/100 *((100-ther)/100 * ((100-hydr)/100 *((100-pred)/100 *(0.9 * getTotal(i)))))), ChartData('Establishment', (100-esta)/100 * ((100-badl)/100 *((100-ther)/100 * ((100-hydr)/100 *((100-pred)/100 *(0.9 * getTotal(i))))))), ChartData('Survival', 0.11 * ((100-esta)/100 * ((100-badl)/100 *((100-ther)/100 * ((100-hydr)/100 *((100-pred)/100 *(0.9 * getTotal(i))))))))],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    showCumulativeValues: true,
                                    useSeriesColor: true
                                ),
                            ),
                        ]
                    ),
                    Item('% Die by predation', pred.round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: pred,
                      onChanged: (value) {
                        setState(() {
                          pred = value;
                        });
                      },
                    ),
                    Item('% Die by hydric stress', hydr.round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: hydr,
                      onChanged: (value) {
                        setState(() {
                          hydr = value;
                        });
                      },
                    ),
                    Item('% Die by thermal stress', ther.round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: ther,
                      onChanged: (value) {
                        setState(() {
                          ther = value;
                        });
                      },
                    ),
                    Item('% Die by bad location', badl.round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: badl,
                      onChanged: (value) {
                        setState(() {
                          badl = value;
                        });
                      },
                    ),
                    Item('% establishment', esta.round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: esta,
                      onChanged: (value) {
                        setState(() {
                          esta = value;
                        });
                      },
                    ),
                ],
          ),
        );
    }
}

    class ChartData {
      ChartData(this.x, this.y);
      final String x;
      final double y;
    }