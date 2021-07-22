import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ras/@helpers/SeedIcons.dart';
import 'package:ras/models/Gmap.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Point.dart';
import 'package:ras/route-args/MapViewArgs.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:uuid/uuid.dart';
import 'package:ras/models/kml/Polygon.dart' as poly;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _initPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  static int shapeType = 0;
  // 0 = none; 1 = placemark; 2 = polygon ...

  static bool editing = false;

  static bool isLoaded = false;

  late BitmapDescriptor polygonVertexIcon;
  late BitmapDescriptor currentSeedMarkerIcon;

  Set<Marker> _markers = Set<Marker>();
  List<LatLng> _polygonVertex = [];
  Set<Polygon> _polygons = new Set();

  var uuid = Uuid();
  String currentMarkerId = '';
  String currentVertexId = '';
  Seed currentSeedMarker =
      Seed('', 'Default', '', SeedIcons.list[0], 0, 0, 0, 0, 0, 0);

  _setUserLocation() async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      _determinePosition();
    } else {
      _showAlertDialog(
          'Ops!', 'You need to device location to use this feature');
    }
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

  _handleTap(LatLng value) {
    switch (shapeType) {
      case 1:
        // new marker
        var id = uuid.v1();
        Marker m = Marker(
            markerId: MarkerId(id),
            infoWindow: InfoWindow(title: currentSeedMarker.commonName),
            position: value,
            draggable: true,
            icon: currentSeedMarkerIcon,
            onTap: () {
              setState(() {
                editing = true;
                currentMarkerId = id;
                shapeType = 1;
              });
            });
        setState(() {
          _markers.add(m);
        });
        break;
      case 2:
        // add vertex
        var id = uuid.v1();
        Marker vertex = Marker(
            markerId: MarkerId(id),
            position: value,
            draggable: false,
            icon: polygonVertexIcon,
            onTap: () {
              setState(() {
                currentVertexId = id;
                editing = true;
                shapeType = 2;
              });
            },
            onDragEnd: (newValue) {});
        setState(() {
          _polygonVertex.add(vertex.position);
          _markers.add(vertex);
          if (_polygonVertex.length >= 3) _placePolygon();
        });
        break;
      default:
    }
  }

  _removeSeedMarker() {
    setState(() {
      _markers.removeWhere(
          (element) => element.markerId == MarkerId(currentMarkerId));
    });
  }

  _placeSeedInMyPosition() async {
    LatLng position = await _determinePosition();
    _handleTap(position);
  }

  _placePolygon() {
    setState(() {
      _polygons.add(Polygon(
        polygonId: PolygonId('area'),
        points: _polygonVertex,
        strokeColor: Colors.yellow,
        strokeWidth: 1,
        fillColor: Colors.yellow.withOpacity(0.15),
      ));
    });
  }

  _removePolygon() {
    _polygons = Set();
    _polygonVertex.forEach((vertex) {
      _markers.removeWhere((element) => element.position == vertex);
    });
    _polygonVertex = [];
  }

  _removeElement() {
    switch (shapeType) {
      case 1:
        _removeSeedMarker();
        break;
      case 2:
        _removePolygon();
        break;
      default:
        break;
    }
  }

  _generateKML() {
    List<Placemark> placemarks = [];
    poly.Polygon area = poly.Polygon('', []);

    if (_polygons.isNotEmpty) {
      area =
          poly.Polygon(_polygons.first.polygonId.value, _polygons.first.points);
    }

    if (_markers.isNotEmpty) {
      _markers.forEach((element) {
        placemarks.add(Placemark(
            element.markerId.value,
            'seed name',
            'seed description',
            LookAt(element.position.longitude, element.position.latitude,
                '10000', '45', '0'),
            Point(element.position.longitude, element.position.latitude)));
      });
    }
    isLoaded = false;
    editing = false;
    shapeType = 0;
    Gmap geodata = Gmap(placemarks, area, []);
    Navigator.pop(context, geodata);
  }

  init(MapViewArgs args) async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5, size: Size(1, 1)),
            'assets/polyVertex.png')
        .then((onValue) {
      polygonVertexIcon = onValue;
    });
      // init markers
      args.map.markers.forEach((element) {
        var contain = args.map.areaPolygon.coord.where((el) =>
            el.latitude == element.point.lng &&
            el.longitude == element.point.lat);
        if (contain.isEmpty) {
          Marker m = Marker(
              markerId: MarkerId(element.id),
              position: LatLng(element.point.lng, element.point.lat),
              draggable: true,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              onTap: () {
                setState(() {
                  editing = false;
                  currentMarkerId = element.id;
                  shapeType = 1;
                });
              });
          _markers.add(m);
        } else {
          Marker vertex = Marker(
              markerId: MarkerId(element.id),
              position: LatLng(element.point.lng, element.point.lat),
              draggable: false,
              icon: polygonVertexIcon,
              onTap: () {
                setState(() {
                  currentVertexId = element.id;
                  editing = false;
                  shapeType = 2;
                });
              },
              onDragEnd: (newValue) {});
          _markers.add(vertex);
        }
      });

      // init polygons
      args.map.areaPolygon.coord.forEach((element) {
        _polygonVertex.add(element);
        _placePolygon();
      });

      // init point
      if (args.map.areaPolygon.coord.length > 0) {
        _initPosition = CameraPosition(
          target: args.map.areaPolygon.coord[0],
          zoom: 15,
        );
      } else if (args.map.markers.length > 0) {
        _initPosition = CameraPosition(
          target: LatLng(
              args.map.markers[0].point.lng, args.map.markers[0].point.lat),
          zoom: 15,
        );
      }

      isLoaded = true;
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5, size: Size(1, 1)),
            'assets/polyVertex.png')
        .then((onValue) {
      polygonVertexIcon = onValue;

      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 2.5, size: Size(1, 1)),
              '${currentSeedMarker.icon['url']}')
          .then((onValue) {
        currentSeedMarkerIcon = onValue;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MapViewArgs;
    if (!isLoaded) init(args);

    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: _initPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            polygons: _polygons,
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10),
                  child: FloatingActionButton(
                      heroTag: 'btn1',
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, '');
                        isLoaded = false;
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
