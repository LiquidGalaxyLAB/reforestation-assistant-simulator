import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  final bool isHome;

  const MyAppBar({Key? key, required this.isHome}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: !widget.isHome
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left),
            )
          : IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              icon: Icon(Icons.info)),
      title: Text(
        'RAS',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      centerTitle: true,
      bottom: widget.isHome
          ? TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.emoji_flags),
                  text: 'Projects',
                ),
                Tab(
                  icon: Icon(Icons.yard_outlined),
                  text: 'Seeds',
                ),
              ],
            )
          : null,
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
