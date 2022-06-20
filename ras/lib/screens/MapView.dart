import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/models/kml/LookAt.dart';
import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Point.dart';
import 'package:ras/route-args/MapViewArgs.dart';
import 'package:ras/services/ImageProcessing.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:uuid/uuid.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // MAPS ATTRIBUTES
  Completer<GoogleMapController> _controller = Completer(); // Map controller
  CameraPosition initPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  ); // Init position for camera when no data is loaded
  Set<Marker> markers = Set<Marker>();

  // HELPERS
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
    final args = ModalRoute.of(context)!.settings.arguments as MapViewArgs;
    if (!loaded) init(args);

    return new Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          mapType: MapType.terrain,
          initialCameraPosition: initPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
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
                          Navigator.of(context).pop();
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

  init(MapViewArgs args) async {
    // set init point
    if (args.map.landingPoint.name != 'none')
      moveCamera(LatLng(
          args.map.landingPoint.point.lat, args.map.landingPoint.point.lng));
    else if (args.map.areaPolygon.coord.isNotEmpty)
      moveCamera(LatLng(args.map.areaPolygon.coord[0].latitude,
          args.map.areaPolygon.coord[0].longitude));
    else if (args.map.markers.isNotEmpty)
      moveCamera(
          LatLng(args.map.markers[0].point.lat, args.map.markers[0].point.lng));

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
        draggable: true,
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
        draggable: true,
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
}
