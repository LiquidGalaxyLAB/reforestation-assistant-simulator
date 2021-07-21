import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Polygon.dart' as poly;

class Gmap {
  List<Placemark> markers;
  poly.Polygon areaPolygon;
  List<Seed> seeds;

  Gmap(this.markers, this.areaPolygon, this.seeds);

  toMap() {
    List<dynamic> mrks = [];
    markers.forEach((element) {
      mrks.add(element.toMap());
    });

    List<dynamic> seedsDyn = [];
    seeds.forEach((element) {
      seedsDyn.add(element.toMap());
     });

    return {
      "markers": mrks,
      "areaPolygon": areaPolygon.toMap(),
      "seeds": seedsDyn
    };
  }

  static fromMap(dynamic map) {
    List<Placemark> markers = [];
    List<Seed> seeds = [];
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
      if (map['seeds'] != null) {
        seeds = Seed.fromMapList(map['seeds']);
      }
    }

    return Gmap(markers, polygon, seeds);
  }
}
