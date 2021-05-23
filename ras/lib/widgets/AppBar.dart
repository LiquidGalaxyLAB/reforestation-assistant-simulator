import 'package:flutter/material.dart';

Widget myAppBar() {
  return AppBar(
    title: Text(
      'RAS',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    ),
    leading: Image.asset(
      'assets/treeIcon.png',
      scale: 1,
    ),
    backgroundColor: Colors.blue.shade900,
  );
}
