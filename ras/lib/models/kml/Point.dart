class Point {
  String lat;
  String lng;

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
