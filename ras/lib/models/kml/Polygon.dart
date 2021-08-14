import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polygon {
  String id;
  List<LatLng> coord;

  static dynamic style = {
    "lineStyle": {"color": "ff7fffff"},
    "polyStyle": {
      "color": "b37fffff",
    }
  };

  Polygon(this.id, this.coord);

  generateTag() {
    return '''
  <Style id="$id">
    <LineStyle>
      <color>${style['lineStyle']['color']}</color>
      <width>5</width>
    </LineStyle>
    <PolyStyle>
      <color>${style['polyStyle']['color']}</color>
    </PolyStyle>
  </Style>
  <Placemark>
		<name>AREA</name>
		<styleUrl>$id</styleUrl>
    <Polygon>
      <extrude>1</extrude>
      <tesselate>1</tesselate>
      <altitudeMode>relativeToGround</altitudeMode>
      <gx:drawOrder>1</gx:drawOrder>
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
      stringPoints += element.longitude.toString() +
          ',' +
          element.latitude.toString() +
          ',10' +
          '\n';
    });

    stringPoints += this.coord[0].longitude.toString() +
          ',' +
          this.coord[0].latitude.toString() +
          ',10' +
          '\n';

    return stringPoints;
  }
}
