import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Polygon.dart' as poly;

class Gmap {
  List<Placemark> markers;
  poly.Polygon areaPolygon;

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
    poly.Polygon polygon = poly.Polygon('', []);

    if (map != null) {
      if (map['markers'] != null) {
        markers = Placemark.fromMapList(map['markers']);
      }
      if (map['areaPolygon'] != null) {
        List<LatLng> pointList = [];
        map['areaPolygon']['coord'].forEach((element) {
          pointList.add(LatLng(element['lat'], element['long']));
        });
        polygon = poly.Polygon(map['areaPolygon']['id'], pointList);
      }
    }

    return Gmap(markers, polygon);
  }
}
