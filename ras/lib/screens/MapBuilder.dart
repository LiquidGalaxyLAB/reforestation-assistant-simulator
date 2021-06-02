// import 'package:flutter/material.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_map/flutter_map.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:latlong/latlong.dart' show LatLng;

// class MapBuilder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: FlutterMap(
//           options: MapOptions(
//             center: LatLng(51.5, -0.09),
//             zoom: 13.0,
//           ),
//           layers: [
//             TileLayerOptions(
//                 urlTemplate:
//                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 subdomains: ['a', 'b', 'c']),
                
//             MarkerLayerOptions(
//               markers: [
//                 Marker(
//                   width: 80.0,
//                   height: 80.0,
//                   point: LatLng(51.5, -0.09),
//                   builder: (ctx) => Container(
//                     child: Icon(Icons.place, color: Colors.red, size: 80),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
