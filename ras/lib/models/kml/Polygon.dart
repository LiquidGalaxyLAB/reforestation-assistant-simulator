import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polygon {
  String id;
  List<LatLng> coord;

  Polygon(this.id, this.coord);

  generateTag() {
    return '''
  <Placemark>
		<name>AREA</name>
		<styleUrl>#m_ylw-pushpin</styleUrl>
    <Polygon id="${this.id}">
      <extrude>4</extrude>
      <altitudeMode>relativeToGround</altitudeMode>
      <tessellate>1</tessellate>
      <outerBoundaryIs>
        <LinearRing>
          <coordinates>
            ${this.coordsToString()}
          </coordinates>
        </LinearRing>
      </outerBoundaryIs>
    </Polygon>
  </Placemark>
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
      stringPoints += element.longitude.toString() + ',' + element.latitude.toString() + ',40' + '\n';
    });

    return stringPoints;
  }

}
