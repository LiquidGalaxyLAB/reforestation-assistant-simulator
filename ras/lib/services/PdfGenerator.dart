import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:downloads_path_provider/downloads_path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pdf/pdf.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pdf/widgets.dart' as pw;
import 'package:ras/models/Project.dart';

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

    getTotalCO2() {
      double qt = 0;
      project.seeds.forEach((element) {
        qt += element.co2PerYear;
      });
      return qt;
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
                'Total number of ran days', '${project.totalNumberOfRains}'),
            title('SPECIES INFORMATION'),
            attribute('Total CO2 capture', '${getTotalCO2()}'),
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
                          '${project.seeds[index].co2PerYear} per year'),
                      attribute('Estimated longevity',
                          '${project.seeds[index].estimatedLongevity} years'),
                      attribute('Estimated final height',
                          '${project.seeds[index].estimatedFinalHeight} m'),
                    ]),
                  );
                },
                itemCount: project.seeds.length),
            title('AREA INFORMATION'),
            attribute('Area covered', '${project.areaCovered}m²'),
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
            attribute('Size of Deposit', '${project.sizeOfDeposit}%'),
            attribute('Size of Seedballs', '${project.sizeOfSeedballs}%'),
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
