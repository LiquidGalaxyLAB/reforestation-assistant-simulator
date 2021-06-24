class Seed {
  String id;
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
      this.id,
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
      ));
    });
    return seeds;
  }
}
