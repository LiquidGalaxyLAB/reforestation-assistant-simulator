import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ras/@helpers/SeedIcons.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/route-args/MapViewArgs.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:uuid/uuid.dart';

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

  int shapeType = 0;
  // 0 = none; 1 = placemark; 2 = polygon ...

  bool editing = false;

  bool isLoaded = false;

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

  init(MapViewArgs args) async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5, size: Size(1, 1)),
            'assets/appIcons/polyVertex.png')
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
            'assets/appIcons/polyVertex.png')
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
