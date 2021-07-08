import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Point.dart';

class Placemark {
  String id;
  String name;
  String description;
  LookAt lookAt;
  Point point;

  Placemark(this.id,this.name, this.description, this.lookAt, this.point);

  generateTag() {
    return '''
    <Placemark id="${this.id}">
      <name>${this.name}</name>
      <description>${this.description}</description>
      ${this.lookAt.generateTag()}
      <styleUrl>#m_ylw-pushpin</styleUrl>
      ${this.point.generateTag()}
    </Placemark>
    ''';
  }

  toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "lookAt": lookAt.toMap(),
      "point": point.toMap(),
    };
  }

  static List<Placemark> fromMapList(List<dynamic> list) {
    List<Placemark> markers = [];
    list.forEach((element) {
      markers.add(Placemark(
        element['id'],
        element['name'],
        element['description'],
        LookAt.fromMap(element['lookAt']),
        Point.fromMap(element['point']),
      ));
    });
    return markers;
  }

  @override
  String toString() {
    return super.toString();
  }
}
