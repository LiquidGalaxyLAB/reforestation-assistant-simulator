import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/treeIcon.png',
            scale: 2,
          ),
          Text(
            'RAS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
      // title: Text(
      //   'RAS',
      //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      // ),
      // centerTitle: true,
      actions: [
        ModalRoute.of(context)!.settings.name != '/settings'
            ? IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: Icon(Icons.settings),
              )
            : SizedBox(),
      ],
      backgroundColor: Colors.blue.shade900,
    );
  }
}
