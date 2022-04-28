import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ras/models/Gmap.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Point.dart';
import 'package:ras/route-args/MapBuilderArgs.dart';
import 'package:ras/services/ImageProcessing.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:uuid/uuid.dart';
import 'package:ras/models/kml/Polygon.dart' as poly;

class MapBuilder extends StatefulWidget {
  const MapBuilder({Key? key}) : super(key: key);

  @override
  _MapBuilderState createState() => _MapBuilderState();
}

class _MapBuilderState extends State<MapBuilder> {
  // MAPS ATTRIBUTES
  Completer<GoogleMapController> _controller = Completer(); // Map controller
  CameraPosition initPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  ); // Init position for camera when no data is loaded
  Set<Marker> markers = Set<Marker>();

  // HELPERS
  bool isLocationAccessAccepted = false;
  bool loaded = false;
  bool editing = false;
  String shapeType = 'none';
  String currentMarkerId = '';
  var uuid = Uuid();
  BitmapDescriptor currentSeedMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  Seed currentSeedMarker = Seed('', 'none', '', {}, 0, 0, 0, 0, 0, 0);

  // SEED MARKERS
  List<Placemark> seedMarkers = [];

  // LANDING POINT
  Placemark landingPoint = Placemark(
      '',
      'none',
      '',
      LookAt(
        0,
        0,
        '',
        '',
        '',
      ),
      Point(0, 0),
      'landingPoint');

  // POLYGON AREA
  List<LatLng> polygonVertex = [];
  Set<Polygon> polygons = new Set();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MapBuilderArgs;
    if (!loaded) init(args);

    return new Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          mapType: MapType.satellite,
          initialCameraPosition: initPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (value) {
            handleTap(value);
          },
          markers: markers,
          polygons: polygons,
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 10),
                    child: FloatingActionButton(
                        heroTag: 'backBtn',
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: Icon(Icons.arrow_back),
                        onPressed: () {
                          showReturnDialog('Are you sure you want to go back?',
                              'All the changes you made in the map will be lost');
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 10),
                    child: FloatingActionButton(
                        heroTag: 'savebtn',
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: Icon(Icons.save),
                        onPressed: () {
                          saveMap();
                        }),
                  ),
                ],
              ),
              editing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, right: 10),
                              child: FloatingActionButton(
                                  heroTag: 'deleteBtn',
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  child: Icon(Icons.delete),
                                  onPressed: () {
                                    // delete shape
                                    setState(() {
                                      removeElement();
                                      setState(() {
                                        editing = false;
                                        shapeType = 'none';
                                      });
                                    });
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, right: 10),
                              child: FloatingActionButton(
                                  heroTag: 'finifhBtn',
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  child: Icon(Icons.check),
                                  onPressed: () {
                                    // finished editing shape
                                    setState(() {
                                      shapeType = 'none';
                                      editing = false;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        shapeType == 'seedMarker'
                            ? GestureDetector(
                                onTap: () {
                                  selectSeed();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: currentSeedMarker.commonName ==
                                                'none'
                                            ? Icon(
                                                Icons.place,
                                                color: Colors.red,
                                              )
                                            : Image.asset(
                                                currentSeedMarker.icon['url'],
                                                scale: 1,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      Text(
                                        '${currentSeedMarker.commonName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Icon(
                                          Icons.change_circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: FloatingActionButton(
                              heroTag: 'addMarker',
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Image.asset(
                                'assets/appIcons/new-seed-marker.png',
                                height: 25,
                                width: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Shape now is Placemark
                                  shapeType = 'seedMarker';
                                  editing = true;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: FloatingActionButton(
                              heroTag: 'addMarkerPosition',
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Image.asset(
                                'assets/appIcons/place-seed-marker.png',
                                height: 25,
                                width: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  shapeType = 'seedMarker';
                                  placeSeedInMyPosition();
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: FloatingActionButton(
                              heroTag: 'polygonBtn',
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Image.asset(
                                'assets/appIcons/selection-marker.png',
                                height: 25,
                                width: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  shapeType = "polygon";
                                  editing = true;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: FloatingActionButton(
                              heroTag: 'landpointBtn',
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Image.asset(
                                'assets/appIcons/landing_white.png',
                                height: 25,
                                width: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  // landing point
                                  shapeType = 'landingPoint';
                                  editing = true;
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 90.0),
                          child: FloatingActionButton(
                              heroTag: 'userLocationBtn',
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Icon(Icons.my_location_rounded),
                              onPressed: () {
                                _setUserLocation();
                              }),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    ));
  }

  init(MapBuilderArgs args) {
    if (!args.isNew) {
      // set init point
      if (args.map.landingPoint.name != 'none')
        moveCamera(LatLng(
            args.map.landingPoint.point.lat, args.map.landingPoint.point.lng));
      else if (args.map.areaPolygon.coord.isNotEmpty)
        moveCamera(LatLng(args.map.areaPolygon.coord[0].latitude,
            args.map.areaPolygon.coord[0].longitude));
      else if (args.map.markers.isNotEmpty)
        moveCamera(LatLng(
            args.map.markers[0].point.lat, args.map.markers[0].point.lng));

      // place seed markers
      args.map.markers.forEach((element) {
        setState(() {
          seedMarkers.add(element);
          placeSeedMarker(element);
        });
      });

      // place landing point
      placeLandingPoint(LatLng(
          args.map.landingPoint.point.lat, args.map.landingPoint.point.lng));

      // place polygon
      if (args.map.areaPolygon.coord.isNotEmpty) {
        Future.forEach(args.map.areaPolygon.coord, (LatLng element) async {
          await placePolygonVertex(LatLng(element.latitude, element.longitude));
        });
      }
    }

    setState(() {
      loaded = true;
    });
  }

  Future moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition newPosition;
    newPosition = CameraPosition(
      target: position,
      zoom: 15,
    );

    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(newPosition);
    controller.moveCamera(cameraUpdate);
  }

  // DELETE MAP ELEMENTS
  removeElement() {
    switch (shapeType) {
      case 'seedMarker':
        removeSeedMarker();
        break;
      case 'polygon':
        removePolygon();
        break;
      case 'landingPoint':
        removeLandingPoint();
        break;
      default:
        break;
    }
  }

  removeSeedMarker() {
    setState(() {
      markers
          .removeWhere((element) => element.markerId.value == currentMarkerId);
      seedMarkers.removeWhere((element) => element.id == currentMarkerId);
    });
  }

  removePolygon() {
    polygons = Set();
    polygonVertex.forEach((vertex) {
      markers.removeWhere((element) => element.position == vertex);
    });
    polygonVertex = [];
  }

  removeLandingPoint() {
    setState(() {
      markers
          .removeWhere((element) => element.markerId.value == 'landingPoint');
      landingPoint = Placemark(
          '',
          'none',
          '',
          LookAt(
            0,
            0,
            '',
            '',
            '',
          ),
          Point(0, 0),
          'landingPoint');
    });
  }

  // SAVE MAP
  saveMap() {
    Gmap geodata = Gmap(
      seedMarkers,
      polygons.isNotEmpty
          ? poly.Polygon(polygons.first.polygonId.value, polygons.first.points)
          : poly.Polygon('', []),
      landingPoint,
    );
    Navigator.pop(context, geodata);
  }

  // HANDLE TAPS ON MAP
  handleTap(LatLng point) {
    switch (shapeType) {
      case 'seedMarker':
        // put new placemark to array of seedMarkers
        setState(() {
          seedMarkers.add(newSeedMarker(point));
        });
        break;
      case 'landingPoint':
        // put a landing point into the map
        placeLandingPoint(point);
        break;
      case 'polygon':
        placePolygonVertex(point);
        break;
      default:
        break;
    }
  }

  placePolygonVertex(LatLng point) async {
    final icon = await getBitmapDescriptorFromAssetBytes(
        'assets/appIcons/polyVertex.png', 90);
    // add vertex
    var id = uuid.v1();
    Marker vertex = Marker(
        markerId: MarkerId(id),
        position: point,
        draggable: false,
        icon: icon,
        onTap: () {
          setState(() {
            editing = true;
            shapeType = 'polygon';
          });
        },
        onDragEnd: (newValue) {});
    setState(() {
      polygonVertex.add(vertex.position);
      markers.add(vertex);
      if (polygonVertex.length >= 3) placePolygon();
    });
  }

  placePolygon() {
    setState(() {
      polygons.add(Polygon(
        polygonId: PolygonId('area'),
        points: polygonVertex,
        strokeColor: Colors.yellow,
        strokeWidth: 1,
        fillColor: Colors.yellow.withOpacity(0.15),
      ));
    });
  }

  placeLandingPoint(LatLng point) async {
    final landIcon = await getBitmapDescriptorFromAssetBytes(
        'assets/appIcons/landpoint.png', 150);
    Marker m = Marker(
        markerId: MarkerId('landingPoint'),
        infoWindow: InfoWindow(title: 'Landing Point'),
        position: point,
        draggable: false,
        icon: landIcon,
        onTap: () {
          setState(() {
            editing = true;
            shapeType = 'landingPoint';
          });
        });
    setState(() {
      landingPoint = Placemark(
          'landingPoint',
          'Landing Point',
          'The place where the drone will take off',
          LookAt(point.longitude, point.latitude, '10000', '45', '0'),
          Point(point.latitude, point.longitude),
          'landingPoint');
      markers.add(m);
    });
  }

  placeSeedMarker(Placemark seedM) async {
    Seed seed = Seed.fromMap(seedM.customData['seed']);
    final icon;
    if (seed.commonName == 'none')
      icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    else
      icon = await getBitmapDescriptorFromAssetBytes(seed.icon['url'], 150);
    Marker m = Marker(
        markerId: MarkerId(seedM.id),
        infoWindow: InfoWindow(title: seedM.name),
        position: LatLng(seedM.point.lat, seedM.point.lng),
        draggable: false,
        icon: icon,
        onTap: () {
          setState(() {
            currentMarkerId = seedM.id;
            editing = true;
            shapeType = 'seedMarker';
          });
        });
    setState(() {
      markers.add(m);
    });
  }

  newSeedMarker(LatLng point) {
    Placemark newSeed;
    // new google marker
    var id = uuid.v1();
    Marker m = Marker(
        markerId: MarkerId(id),
        infoWindow: InfoWindow(title: currentSeedMarker.commonName),
        position: point,
        draggable: false,
        icon: currentSeedMarkerIcon,
        onTap: () {
          setState(() {
            currentMarkerId = id;
            editing = true;
            shapeType = 'seedMarker';
          });
        });

    newSeed = Placemark(
        id,
        currentSeedMarker.commonName,
        currentSeedMarker.scientificName,
        LookAt(point.longitude, point.latitude, '10000', '45', '0'),
        Point(point.latitude, point.longitude),
        'seedMarker',
        customData: {
          "seed": currentSeedMarker.toMap(),
        });

    markers.add(m);

    return newSeed;
  }

  // SELECT SEED
  selectSeed() {
    final args = ModalRoute.of(context)!.settings.arguments as MapBuilderArgs;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose species'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter alertState) {
              return Container(
                width: 500,
                height: 500,
                child: args.seeds.length == 0
                    ? Text(
                        'Please add species to the project to select them here',
                        style: TextStyle(color: Colors.grey),
                      )
                    : ListView.builder(
                        itemCount: args.seeds.length,
                        itemBuilder: (context, index) {
                          Seed seed = args.seeds[index];
                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                seed.icon['url'],
                                scale: 1,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text('${seed.commonName}'),
                            subtitle: Text('${seed.scientificName}'),
                            onTap: () async {
                              final icon =
                                  await getBitmapDescriptorFromAssetBytes(
                                      seed.icon['url'], 150);
                              setState(() {
                                currentSeedMarkerIcon = icon;
                                currentSeedMarker = seed;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }),
              );
            }),
          );
        });
  }

  checkAccessLocationModal(success) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'This app collects data to enable "Get my current position" and "Place seed in my position" even when the app is closed and not used'),
            content: Text(''),
            actions: <Widget>[
              OutlinedButton(
                child: Text("DENY"),
                onPressed: () {
                  setState(() {
                    isLocationAccessAccepted = true;
                  });
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
              OutlinedButton(
                child: Text("ACCEPT"),
                onPressed: () {
                  setState(() {
                    isLocationAccessAccepted = true;
                  });
                  success();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
            ],
          );
        });
  }

  // SEED ON USER LOCATION
  _setUserLocation() async {
    // Check if user allows to access location
    success() async {
      if (isLocationAccessAccepted) {
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          _determinePosition();
        } else {
          _showAlertDialog(
              'Ops!', 'You need to enable device location to use this feature');
        }
      }
    }

    await checkAccessLocationModal(success);
  }

  Future<LatLng> _determinePosition() async {
    Position position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    return LatLng(position.latitude, position.longitude);
  }

// MODALS
  _showAlertDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: Text('$msg'),
            actions: <Widget>[
              OutlinedButton(
                child: Text("CLOSE"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
            ],
          );
        });
  }

  showReturnDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: Text('$msg'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text("YES"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

// PLACE SEED IN MY POSITION
  placeSeedInMyPosition() async {
    // Check if user allows to access location
    success() async {
      if (isLocationAccessAccepted) {
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          LatLng position = await _determinePosition();
          handleTap(position);
        } else {
          _showAlertDialog(
              'Ops!', 'You need to enable device location to use this feature');
        }
      }
    }

    await checkAccessLocationModal(success);
  }
}
