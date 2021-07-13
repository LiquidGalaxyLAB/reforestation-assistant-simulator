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
      'Drone',
      'Gijón',
      DateTime.parse('2021-06-25'),
      DateTime.parse('2422-06-25'),
      -15,
      27,
      94,
      96,
      [
        seeds[0],
        seeds[1],
        seeds[3],
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
              LookAt(43.54694921619998, -5.537021652090414, '1492.665945696469',
                  '45', '0'),
              Point(43.54694921619998, -5.537021652090414),
            ),
            Placemark(
              uuid.v1(),
              'Pyrola',
              'Pyrola minor',
              LookAt(43.54702069616535, -5.535044697705636, '1492.665945696469',
                  '45', '0'),
              Point(43.54702069616535, -5.535044697705636),
            ),
            Placemark(
              uuid.v1(),
              'Hazel',
              'Corylus avellana',
              LookAt(43.54653476325108, -5.537103092067886, '1492.665945696469',
                  '45', '0'),
              Point(43.54653476325108, -5.537103092067886),
            ),
          ],
          poly.Polygon('AREA', [
            LatLng(-5.53767398012852, 43.54707883115945),
            LatLng(-5.536740107669146, 43.545447737735),
            LatLng(-5.534711203286956, 43.54583519470048),
            LatLng(-5.534377954339718, 43.54724062357167),
          ])),
    ),
    Project(
      '',
      'Mediterranian forest',
      DateTime.parse('2021-06-21'),
      'Drone',
      'East Spain',
      DateTime.parse('2021-06-25'),
      DateTime.parse('2046-06-25'),
      -10,
      42,
      6,
      72,
      [
        seeds[5],
        seeds[6],
        seeds[7],
        seeds[8],
        seeds[9],
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
              LookAt(41.18133716802097, 1.297154402594893, '1492.665945696469',
                  '45', '0'),
              Point(41.18133716802097, 1.297154402594893),
            ),
            Placemark(
              uuid.v1(),
              'Pyrola',
              'Pyrola minor',
              LookAt(41.18020003376241, 1.297145299230351, '1492.665945696469',
                  '45', '0'),
              Point(41.18020003376241, 1.297145299230351),
            ),
            Placemark(
              uuid.v1(),
              'Hazel',
              'Corylus avellana',
              LookAt(41.18112964511963, 1.296974634002921, '1492.665945696469',
                  '45', '0'),
              Point(41.18112964511963, 1.296974634002921),
            ),
          ],
          poly.Polygon('AREA', [
            LatLng(1.294908694546892, 41.18191515769373),
            LatLng(1.29662875956615, 41.18230377069928),
            LatLng(1.296869305404638, 41.18094283127643),
            LatLng(1.298394044132793, 41.1806360002503),
          ])),
    )
  ];
}
