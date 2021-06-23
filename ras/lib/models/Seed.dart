class Seed {
  String commonName;
  String scientificName;
  String icon;
  double co2PerYear;
  double germinativePotential;
  int estimatedLongevity;
  double estimatedFinalHeight;
  double seedCost;
  double establishmentCost;

  Seed(
      this.commonName,
      this.scientificName,
      this.icon,
      this.co2PerYear,
      this.germinativePotential,
      this.estimatedLongevity,
      this.estimatedFinalHeight,
      this.seedCost,
      this.establishmentCost);

  Map<String, dynamic> toMap() {
    return {
      "commonName": commonName,
      "scientificName": scientificName,
      "icon": icon,
      "co2PerYear": co2PerYear,
      "germinativePotential": germinativePotential,
      "estimatedLongevity": estimatedLongevity,
      "estimatedFinalHeight": estimatedFinalHeight,
      "seedCost": seedCost,
      "establishmentCost": establishmentCost,
    };
  }

  static List<Seed> toList(List<dynamic> list) {
    List<Seed> seeds = [];
    list.forEach((element) {
      seeds.add(Seed(
        element['commonName'],
        element['scientificName'],
        element['icon'],
        element['co2PerYear'],
        element['germinativePotential'],
        element['estimatedLongevity'],
        element['estimatedFinalHeight'],
        element['seedCost'],
        element['establishmentCost'],
      ));
    });
    return seeds;
  }
}
