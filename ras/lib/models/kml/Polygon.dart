class Polygon {
  String id;
  List coord;

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

  coordsToString() {
    String stringPoints = '';
    this.coord.forEach((element) {
      stringPoints += element.longitude.toString() + ',' + element.latitude.toString() + ',0' + '\n';
    });

    return stringPoints;
  }

}
