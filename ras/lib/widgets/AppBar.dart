import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  final bool isHome;

  const MyAppBar({Key? key, required this.isHome}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: !widget.isHome
          ? IconButton(
              onPressed: () {
                if (ModalRoute.of(context)!.settings.name ==
                        '/project-builder' ||
                    ModalRoute.of(context)!.settings.name == '/seed-form') {
                  showReturnDialog('Are you sure you want to go back?',
                      'All the changes you made will be lost');
                } else
                  Navigator.of(context).pop();
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
                  text: 'Species',
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
      backgroundColor: Colors.blue,
    );
  }
}
