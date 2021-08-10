import 'package:ras/models/Gmap.dart';
import 'package:ras/models/Seed.dart';

class MapBuilderArgs {
  Gmap map;
  bool isNew;
  List<Seed> seeds;

  MapBuilderArgs(this.map, this.isNew, this.seeds);
}
