class Point {
  double lat;
  double lng;

  Point(this.lat, this.lng);

  generateTag(){
    return '''
      <Point>
        <coordinates>${this.lng},${this.lat}</coordinates>
      </Point>
    ''';
  }
  @override
  String toString() {
    return super.toString();
  }
}
