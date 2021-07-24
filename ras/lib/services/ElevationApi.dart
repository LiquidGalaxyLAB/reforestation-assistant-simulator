import 'package:http/http.dart' as http;
import 'dart:convert';

class ElevationAPi {
  static getElevationOfArea(List<String> coordinates) async {
    String baseUrl = 'https://api.opentopodata.org/v1/eudem25m?locations=';

    coordinates.forEach((element) {
      baseUrl += '|$element';
    });

    var url = Uri.parse(baseUrl);

    try {
      http.Response response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        List results = body['results'];

        List<double> pointsElevation = [];

        results.forEach((element) {
          pointsElevation.add(double.parse(element['elevation']));
        });

        print(pointsElevation);
        return pointsElevation;
      }
    } catch (e) {
      print('Ops, error getting info from elevation API $e');
      return e;
    }
  }
}
