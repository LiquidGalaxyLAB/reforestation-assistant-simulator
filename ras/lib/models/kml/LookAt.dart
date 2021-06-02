class LookAt {
  String lng;
  String lat;
  String range;
  String tilt;
  String heading;

  LookAt(this.lng, this.lat, this.range, this.tilt, this.heading);

  generateTag() {
    return '''
       <LookAt>
        <longitude>${this.lng}</longitude>
        <latitude>${this.lat}</latitude>
        <range>${this.range}</range>
        <tilt>${this.tilt}</tilt>
        <heading>${this.heading}</heading>
      </LookAt>
    ''';
  }

  @override
  String toString() {
    return super.toString();
  }
}
