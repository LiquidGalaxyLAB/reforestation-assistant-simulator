import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Polygon.dart';

class Gmap {
  List<Placemark> markers;
  Polygon areaPolygon;

  Gmap(this.markers, this.areaPolygon);

  toMap() {
    List<dynamic> mrks = [];
    markers.forEach((element) {
      mrks.add(element.toMap());
    });

    return {
      "markers": mrks,
      "areaPolygon": areaPolygon.toMap(),
    };
  }

  static fromMap(dynamic map) {
    List<Placemark> markers = [];
    Polygon polygon = Polygon('', []);

    if (map != null) {
      if (map['markers'] != null) {
        markers = Placemark.fromMapList(map['markers']);
      }
      if (map['areaPolygon'] != null) {
        print('polyyyyy ${map['areaPolygon']}');
        // TO DO: parse polygon
      }
    }

    return Gmap(markers, polygon);
  }
}
