import 'package:http/http.dart' as http;
import 'dart:convert';

// This class uses the Open Topo Data API and free dataset aster30m provided by NASA
class ElevationAPi {
  static getElevationOfArea(List<String> coordinates) async {
    String baseUrl = 'https://api.opentopodata.org/v1/aster30m?locations=';

    coordinates.forEach((element) {
      baseUrl += '|$element';
    });

    var url = Uri.parse(baseUrl);

    try {
      http.Response response = await http.get(url);
      // print('Response status: ${response.statusCode}');
      

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        List results = body['results'];
        // print('Response body: ${body['results']}');

        List pointsElevation = [];

        results.forEach((element) {
          if (element['elevation'] != null) {
            pointsElevation.add(element['elevation']);
          }

          // print(pointsElevation);
        });
        return pointsElevation;
      }
    } catch (e) {
      print('Ops, error getting info from elevation API $e');
      return e;
    }
  }
}
