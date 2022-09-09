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

  late SelectionBehavior _selectionBehavior;
  late List<ChartData> chartData;
  final List<Seed> seeds;
  _SurvivalEstChartState(this.seeds);
  late int _value;
  List<double> pre = [];
  List<double> hyd = [];
  List<double> the = [];
  List<double> bad = [];
  List<double> est = [];

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
  void initState() {
        _selectionBehavior = SelectionBehavior(enable: true);
        _value = 0;
        seeds.forEach((element) {pre.add(80);});
        seeds.forEach((element) {hyd.add(80);});
        seeds.forEach((element) {the.add(50);});
        seeds.forEach((element) {bad.add(50);});
        seeds.forEach((element) {est.add(80);});
        super.initState();
    }

@override
    Widget build(BuildContext context) {
         return Container(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [ SfCartesianChart(
                        selectionType: SelectionType.series,
                        primaryXAxis: CategoryAxis(labelRotation: 45),
                        primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto,title: AxisTitle(text: 'Total Plants',
                                textStyle: TextStyle(color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300))),
                        legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,position: LegendPosition.bottom
                        ),
                        enableMultiSelection: false,
                        series: <ChartSeries>[
                          for (var i = 0; i < seeds.length; i++)
                            StackedAreaSeries<ChartData, String>(
                                name:seeds[i].commonName,
                                dataSource: [ChartData('Initial', 1.0 * getTotal(i)), ChartData('Seeds Sown', 0.9 * getTotal(i)), ChartData('Predation', (100-pre[i])/100 *(0.9 * getTotal(i))), ChartData('Hydric stress', (100-hyd[i])/100 *((100-pre[i])/100 *(0.9 * getTotal(i)))), ChartData('Thermal stress', (100-the[i])/100 * ((100-hyd[i])/100 *((100-pre[i])/100 *(0.9 * getTotal(i))))), ChartData('Bad location', (100-bad[i])/100 *((100-the[i])/100 * ((100-hyd[i])/100 *((100-pre[i])/100 *(0.9 * getTotal(i)))))), ChartData('Establishment', (100-est[i])/100 * ((100-bad[i])/100 *((100-the[i])/100 * ((100-hyd[i])/100 *((100-pre[i])/100 *(0.9 * getTotal(i))))))), ChartData('Survival', 0.11 * ((100-est[i])/100 * ((100-bad[i])/100 *((100-the[i])/100 * ((100-hyd[i])/100 *((100-pre[i])/100 *(0.9 * getTotal(i))))))))],
                                selectionBehavior: _selectionBehavior,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    showCumulativeValues: false,
                                    useSeriesColor: true,
                                ),
                            ),
                        ]
                    ),
                    DropdownButton(
              value: _value,
              items: [
                for(int i = 0; i < seeds.length; i++)
                DropdownMenuItem(
                  child: Text(seeds[i].commonName),
                  value: i,
                ),
                if(seeds.length == 0)
                  DropdownMenuItem(
                  child: Text('None'),
                  value: 0,
                ),
              ],
              onChanged: (int? value) {
                setState(() {
                  _value = value!;
                });
              }),
                    Item('% Die by predation', pre[_value].round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: pre[_value],
                      onChanged: (value) {
                        setState(() {
                          pre[_value] = value;
                        });
                      },
                    ),
                    Item('% Die by hydric stress', hyd[_value].round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: hyd[_value],
                      onChanged: (value) {
                        setState(() {
                          hyd[_value] = value;
                        });
                      },
                    ),
                    Item('% Die by thermal stress', the[_value].round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: the[_value],
                      onChanged: (value) {
                        setState(() {
                          the[_value] = value;
                        });
                      },
                    ),
                    Item('% Die by bad location', bad[_value].round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: bad[_value],
                      onChanged: (value) {
                        setState(() {
                          bad[_value] = value;
                        });
                      },
                    ),
                    Item('% establishment', est[_value].round().toString()),
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: est[_value],
                      onChanged: (value) {
                        setState(() {
                          est[_value] = value;
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