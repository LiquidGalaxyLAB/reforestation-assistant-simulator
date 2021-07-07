import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polygon {
  String id;
  List<LatLng> coord;

  Polygon(this.id, this.coord);

  generateTag() {
    return '''
    <Polygon>
      <extrude>1</extrude>
      <altitudeMode>clampToGround</altitudeMode>
      <tessellate>1</tessellate>
      <outerBoundaryIs>
        <LinearRing>
          <coordinates>
            ${this.coordsToString()}
          </coordinates>
        </LinearRing>
      </outerBoundaryIs>
    </Polygon>
    ''';
  }

  toMap() {
    List<dynamic> coordsMapList = [];
    coord.forEach((element) {
      dynamic obj = {
        "lat": element.latitude,
        "long": element.longitude,
      };
      coordsMapList.add(obj);
    });

    return {
      "id": id,
      "coord": coordsMapList,
    };
  }

  coordsToString() {
    String stringPoints = '';
    this.coord.forEach((element) {
      stringPoints += element.longitude.toString() + ',' + element.latitude.toString() + ',0' + '\n';
    });

    return stringPoints;
  }

}
