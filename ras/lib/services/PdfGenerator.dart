import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:downloads_path_provider/downloads_path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pdf/pdf.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pdf/widgets.dart' as pw;
import 'package:ras/models/Project.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  static Future generatePdf(Project project) async {
    title(String value) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Text(
          value,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    subtitle(String value) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Text(
          value,
          style: pw.TextStyle(fontSize: 14),
        ),
      );
    }

    attribute(String name, String value) {
      return pw.Row(children: [
        pw.Text(
          '$name: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          '$value',
          style: pw.TextStyle(),
        ),
      ]);
    }

  getCO2() {
    double totalCO2 = 0;
    final diff = DateTime.now().difference(DateTime.parse(project.dateOfProject.toString()));
    project.seeds.forEach((element) {
    totalCO2 += element.co2PerYear;
    });
    double CO2 = diff.inDays*(totalCO2/365);
    return CO2.toStringAsFixed(3);
  }

  getCO2Planned() {
    double totalCO2 = 0;
    final diff = DateTime.now().difference(DateTime.parse(project.dateOfProject.toString()));
    project.seeds.forEach((element) {
    totalCO2 += element.co2PerYear;
    });
    double days = diff.inDays + (365.3*8);
    double CO2 = days*(totalCO2/365);
    return CO2.toStringAsFixed(3);
  }

  getFlights(double volume, double diameter) {
    double flights = 0;
    if(diameter == null || volume == null){
        return flights.toString();
    }
    double radius = diameter/20;
    flights = (15136*(volume/100))/(radius*radius*radius);
    flights = 500000 / flights;
    return flights.toStringAsFixed(2);
  }

  getTotalFlights() {
    double flights = 0;
    project.seeds.forEach((element) {
      double vol = project.sizeOfDeposit;
      double diameter = element.seedballDiameter;
      flights += double.parse(getFlights(vol, diameter));
    });
    return flights.toStringAsFixed(2);
  }

  getRadians(double input){
      return input * pi / 180;
  }

  getArea(Project args){
    Project? p = args;
    double area = 0;
    if(p.geodata != null){
    List<LatLng> coord = p.geodata.areaPolygon.coord;
    if(coord.isNotEmpty){
    coord.add(p.geodata.areaPolygon.coord[0]);
    if(coord.length > 2){
      for(int i = 0; i < coord.length - 1; i++){
          var p1 = coord[i];
          var p2 = coord[i+1];
          area += getRadians(p2.longitude-p1.longitude) * (2 + sin(getRadians(p1.latitude)) + sin(getRadians(p2.latitude)));
      }
    }
      area = area * 6378137 * 6378137 / 2;
      area = area * 0.0001;//convert to hectares
    }
    }
    return area.abs();
  }

    final pdf = pw.Document();
    final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    final tempDirectory = await getTemporaryDirectory();
    var savePath = tempDirectory.path;
    final image1 = pw.MemoryImage(await File("$savePath/graphs1.png").readAsBytes());
    final image2 = pw.MemoryImage(await File("$savePath/graphs2.png").readAsBytes());
    final image3 = pw.MemoryImage(await File("$savePath/graphs3.png").readAsBytes());

    var seedsAsMap = <Map<String, String>>[
    for(int i = 0; i < project.seeds.length; i++)
      {
        "common_name": "${project.seeds[i].commonName}",
        "density": "${project.seeds[i].density}",
        "co2PerYear": "${project.seeds[i].co2PerYear}",
        "estimatedLongevity": "${project.seeds[i].estimatedLongevity}",
        "estimatedFinalHeight": "${project.seeds[i].estimatedFinalHeight}",
        "seedballDiameter": "${project.seeds[i].seedballDiameter}",
      },
  ];

  List<List<String>> listSeeds=List.empty(growable: true);
  for(int i=0;i<seedsAsMap.length;i++)
  {
    listSeeds.add(seedsAsMap[i].values.toList());
  }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              text: '${project.projectName}',
              textStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30),
            ),
            title('BASIC INFORMATION'),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Date of project', 'Region', 'Sown mode'],
              <String>['${project.dateOfProject.toString().substring(0, 10)}', 
              '${project.region}',
              '${project.sownMode}'
              ],
            ]),
            title('PROJECT INFORMATION'),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Total Flights', 'CO2 capture until today', 'Planned CO2 capture', 'Size of Deposit', 'Time of Flight'],
              <String>['${getTotalFlights()}',
              '${getCO2()}' + ' kg',
              '${getCO2Planned()}' + ' kg',
              '${project.sizeOfDeposit}% liters',
              '${project.timeOfFlight}' + 'min/hectare'
              ],
            ]),
            title('SOWING WINDOW TIME'),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Minimum Date', 'Maximum Date'],
              <String>['${project.minSwtDate.toString().substring(0, 10)}',
              '${project.maxSwtDate.toString().substring(0, 10)}'
              ],
            ]),
            subtitle('TEMPERATURE'),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Minimum Temp', 'Maximum Temp', 'Avg number of rains', 'Total rainy days'],
              <String>['${project.minSwtTemp}°C',
              '${project.maxSwtTemp}°C', '${project.avgNumberOfRains}', '${project.totalNumberOfRains}'
              ],
            ]),
            title('SPECIES INFORMATION'),
            pw.Table.fromTextArray(context: context, headers: <String>['Common Name', 'Density', 'CO2 capture', 
              'Estimated longevity', 'Estimated final height', 'Seedball Diameter'], data: listSeeds
            ),
            title('AREA INFORMATION'),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Area covered', 'Optimal surface', 'Invalid surface', 'Empty land', 'Orientation', 'Min altitude', 'Max altitude', 'Max distance', 'Min flight height', 'Predation'],
              <String>['${getArea(project).toStringAsFixed(2)} hectares', 
              '${project.validSurface}%',
              '${project.notValidSurface}%',
              '${project.emptyLand}%',
              '${project.orientation}','${project.minAltTerrain} m','${project.maxAltTerrain} m',
              '${project.maxDistance} m','${project.minFlightHeight} m', '${project.predation}%'
              ],
            ]),
            title('SOIL ATTRIBUTES'),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Depth', 'PH', 'Fractured', 'Hummus presence', 'Inclination'],
              <String>['${project.depth} m',
              '${project.ph}',
              '${project.fractured ? 'Yes' : 'No'}',
              '${project.hummus}',
              '${project.inclination}% | ${(project.inclination / 100) * 360}°'
              ],
            ]),
          ];
        },
      ),
    );

    pdf.addPage(pw.MultiPage(build: (pw.Context context) {
      return [ 
        pw.Row(
            children: [
            pw.Container(
              width: 250,
              height: 720,
              decoration: pw.BoxDecoration(
                image: pw.DecorationImage(
                  fit: pw.BoxFit.contain,
                  image: image1
                ),
              ),
            ),
            pw.Spacer(flex: 1),
            pw.Column(
              children: [
                          pw.Container(
  width: 200,
  height: 320,
  decoration: pw.BoxDecoration(
    image: pw.DecorationImage(
      fit: pw.BoxFit.contain,
      image: image2
    ),
  ),
),
            pw.Container(
  width: 200,
  height: 320,
  decoration: pw.BoxDecoration(
    image: pw.DecorationImage(
      fit: pw.BoxFit.contain,
      image: image3
    ),
  ),
),
              ],
            ),
          ],
      ),
      ];
    })); 

    var path = downloadsDirectory.path;
    final file = File("$path/${project.projectName}.pdf");

    return await file.writeAsBytes(await pdf.save());
  }
}
