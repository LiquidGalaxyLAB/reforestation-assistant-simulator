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

    final pdf = pw.Document();
    final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

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
            attribute('Date of project',
                '${project.dateOfProject.toString().substring(0, 10)}'),
            attribute('Area covered', 'XX'),
            attribute('Region', '${project.region}'),
            attribute('Sown mode', '${project.sownMode}'),
            title('PROJECT INFORMATION'),
            attribute('Total Flights', '${getTotalFlights()}'),
            attribute('CO2 capture until today', '${getCO2()}' + ' kg'),
            attribute('Planned CO2 capture', '${getCO2Planned()}' + ' kg'),
            attribute('Size of Deposit', '${project.sizeOfDeposit}% liters'),
            title('SOWING WINDOW TIME'),
            subtitle('DATES'),
            attribute(
                'Minimum', '${project.minSwtDate.toString().substring(0, 10)}'),
            attribute(
                'Maximum', '${project.maxSwtDate.toString().substring(0, 10)}'),
            subtitle('TEMPERATURE'),
            attribute('Minimum', '${project.minSwtTemp}°C'),
            attribute('Maximum', '${project.maxSwtTemp}°C'),
            attribute('Average number of rains', '${project.avgNumberOfRains}'),
            attribute(
                'Total number of rainy days', '${project.totalNumberOfRains}'),
            title('SPECIES INFORMATION'),
            subtitle('SEEDS'),
            pw.ListView.builder(
                itemBuilder: (pw.Context context, int index) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 10),
                    child: pw.Column(children: [
                      attribute(
                          'Common name', '${project.seeds[index].commonName}'),
                      attribute(
                          'Density', '${project.seeds[index].density} plants per hectare'),
                      attribute('Survival probability', 'XX'),
                      attribute('Estimated CO2 capture',
                          '${project.seeds[index].co2PerYear} kg per year'),
                      attribute('Estimated longevity',
                          '${project.seeds[index].estimatedLongevity} years'),
                      attribute('Estimated final height',
                          '${project.seeds[index].estimatedFinalHeight} m'),
                      attribute(
                          'Seedball Diameter', '${project.seeds[index].seedballDiameter} mm'),
                    ]),
                  );
                },
                itemCount: project.seeds.length),
            title('AREA INFORMATION'),
            attribute('Area covered', '${getArea(project).toStringAsFixed(2)} hectares'),
            attribute('Optimal surface', '${project.validSurface}%'),
            attribute('Invalid surface', '${project.notValidSurface}%'),
            attribute('Empty land', '${project.emptyLand}%'),
            attribute('Orientation', '${project.orientation}'),
            attribute('Minimum altitude of the terrain',
                '${project.minAltTerrain} m'),
            attribute('Maximum altitude of the terrain',
                '${project.maxAltTerrain} m'),
            attribute('Maximum distance', '${project.maxDistance} m'),
            attribute('Minimum flight height', '${project.minFlightHeight} m'),
            attribute('Predation', '${project.predation}%'),
            title('SOIL ATTRIBUTES'),
            attribute('Depth', '${project.depth} m'),
            attribute('PH', '${project.ph}'),
            attribute('Fractured', '${project.fractured ? 'Yes' : 'No'}'),
            attribute('Hummus presence', '${project.hummus}'),
            attribute('Inclination',
                '${project.inclination}% | ${(project.inclination / 100) * 360}°'),
          ];
        },
      ),
    );

    var path = downloadsDirectory.path;
    final file = File("$path/${project.projectName}.pdf");

    return await file.writeAsBytes(await pdf.save());
  }
}
