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
    <Placemark>
      <name>${this.name}</name>
      <description>${this.description}</description>
      ${this.lookAt.generateTag()}
      ${this.point.generateTag()}
    </Placemark>
    ''';
  }

  @override
  String toString() {
    return super.toString();
  }
}
