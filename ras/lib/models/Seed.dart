class Seed {
  String id;
  String commonName;
  String scientificName;
  dynamic icon;
  double co2PerYear;
  double germinativePotential;
  int estimatedLongevity;
  double estimatedFinalHeight;
  double seedCost;
  double establishmentCost;
  double? density;

  Seed(
      this.id,
      this.commonName,
      this.scientificName,
      this.icon,
      this.co2PerYear,
      this.germinativePotential,
      this.estimatedLongevity,
      this.estimatedFinalHeight,
      this.seedCost,
      this.establishmentCost,
      {this.density});

  static fromMap(dynamic data) {
    Seed seed = Seed(
        data['id'],
        data['commonName'],
        data['scientificName'],
        data['icon'],
        data['co2PerYear'],
        data['germinativePotential'],
        data['estimatedLongevity'],
        data['estimatedFinalHeight'],
        data['seedCost'],
        data['establishmentCost']);
    return seed;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "commonName": commonName,
      "scientificName": scientificName,
      "icon": icon,
      "co2PerYear": co2PerYear,
      "germinativePotential": germinativePotential,
      "estimatedLongevity": estimatedLongevity,
      "estimatedFinalHeight": estimatedFinalHeight,
      "seedCost": seedCost,
      "establishmentCost": establishmentCost,
      "density": density,
    };
  }

  static List<Seed> toList(List<dynamic> list) {
    List<Seed> seeds = [];
    list.forEach((element) {
      seeds.add(Seed(
        element.key,
        element.value['commonName'],
        element.value['scientificName'],
        element.value['icon'],
        element.value['co2PerYear'],
        element.value['germinativePotential'],
        element.value['estimatedLongevity'],
        element.value['estimatedFinalHeight'],
        element.value['seedCost'],
        element.value['establishmentCost'],
        density: element.value['density'],
      ));
    });
    return seeds;
  }

  static List<Seed> fromMapList(List<dynamic> list) {
    List<Seed> seeds = [];
    list.forEach((element) {
      seeds.add(Seed(
        element['id'],
        element['commonName'],
        element['scientificName'],
        element['icon'],
        element['co2PerYear'],
        element['germinativePotential'],
        element['estimatedLongevity'],
        element['estimatedFinalHeight'],
        element['seedCost'],
        element['establishmentCost'],
        density: element['density'],
      ));
    });
    return seeds;
  }
}
