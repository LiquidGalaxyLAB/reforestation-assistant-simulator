import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ras/@fakedb/Seeds.dart';
import 'package:ras/models/Gmap.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Point.dart';
import 'package:ras/models/kml/Polygon.dart' as poly;
import 'package:uuid/uuid.dart';

var uuid = Uuid();
List<Seed> seeds = FakeSeeds.seeds;

class FakeProjects {
  static List<Project> projects = [
    Project(
      '',
      'Atlantic forest (Spain)',
      DateTime.parse('2021-06-21'),
      'By Drone',
      'Gijón',
      DateTime.parse('2021-06-25'),
      DateTime.parse('2422-06-25'),
      -15,
      27,
      94,
      96,
      [
        Seed('', 'Blueberry', 'Vaccinium myrtillus', '', 1.8, 97.0, 20, 2.5,
            0.40, 32,
            density: 20),
        Seed('', 'Pyrola', 'Pyrola minor', '', 3.4, 97.0, 15, 0.2, 2.50, 40,
            density: 10),
        Seed('', 'Hazel', 'Corylus avellana', '', 5.2, 92, 120, 4, 1.55, 100,
            density: 5),
      ],
      85,
      15,
      7,
      'West',
      800,
      1500,
      786.21,
      1200,
      7,
      false,
      8,
      2,
      Gmap(
          [
            Placemark(
              uuid.v1(),
              'Blueberry',
              'Vaccinium myrtillus',
              LookAt(-5.537021652090414, 43.54694921619998, '1492.665945696469',
                  '45', '0'),
              Point(-5.537021652090414, 43.54694921619998),
            ),
            Placemark(
              uuid.v1(),
              'Pyrola',
              'Pyrola minor',
              LookAt(-5.535044697705636, 43.54702069616535, '1492.665945696469',
                  '45', '0'),
              Point(-5.535044697705636, 43.54702069616535),
            ),
            Placemark(
              uuid.v1(),
              'Hazel',
              'Corylus avellana',
              LookAt(-5.537103092067886, 43.54653476325108, '1492.665945696469',
                  '45', '0'),
              Point(-5.537103092067886, 43.54653476325108),
            ),
          ],
          poly.Polygon('AREA', [
            LatLng(43.54707883115945, -5.53767398012852),
            LatLng(43.545447737735, -5.536740107669146),
            LatLng(43.54583519470048, -5.534711203286956),
            LatLng(43.54724062357167, -5.534377954339718),
          ])),
    ),
    Project(
      '',
      'Mediterranian forest',
      DateTime.parse('2021-06-21'),
      'By Drone',
      'East Spain',
      DateTime.parse('2021-06-25'),
      DateTime.parse('2046-06-25'),
      -10,
      42,
      6,
      72,
      [
        Seed('', 'Holm oak', 'Quercus ilex', '', 5, 80, 260, 20, 0.39, 593.17,
            density: 20),
        Seed('', 'London plane', 'Platanus x hispanica', '', 21.6, 90, 300, 30,
            0.6, 184.2,
            density: 20),
        Seed('', 'Maritime pine', 'Pinus pinaster', '', 18.3, 90, 260, 30, 2.33,
            2.33,
            density: 20),
        Seed('', 'European red pine', 'Pinus sylvestris', '', 3.3, 80, 200, 30,
            1.99, 1.99,
            density: 20),
        Seed('', 'Monterey pine', 'Pinus radiata', '', 38.3, 75, 150, 40, 3.65,
            3.65,
            density: 20),
      ],
      95,
      5,
      40,
      'East',
      600,
      1200,
      368.25,
      800,
      6,
      false,
      9,
      3,
      Gmap(
          [
            Placemark(
              uuid.v1(),
              'Holm oak',
              'Quercus ilex',
              LookAt(1.297154402594893, 41.18133716802097, '1492.665945696469',
                  '45', '0'),
              Point(1.297154402594893, 41.18133716802097),
            ),
            Placemark(
              uuid.v1(),
              'Pyrola',
              'Pyrola minor',
              LookAt(1.297145299230351, 41.18020003376241, '1492.665945696469',
                  '45', '0'),
              Point(1.297145299230351, 41.18020003376241),
            ),
            Placemark(
              uuid.v1(),
              'Hazel',
              'Corylus avellana',
              LookAt(1.296974634002921, 41.18112964511963, '1492.665945696469',
                  '45', '0'),
              Point(1.296974634002921, 41.18112964511963),
            ),
          ],
          poly.Polygon('AREA', [
            LatLng(41.18191515769373, 1.294908694546892), //1
            LatLng(41.18230377069928, 1.29662875956615), //2
            LatLng(41.1806360002503, 1.298394044132793), //3
            LatLng(41.18094283127643, 1.296869305404638), //4
          ])),
    )
  ];
}
