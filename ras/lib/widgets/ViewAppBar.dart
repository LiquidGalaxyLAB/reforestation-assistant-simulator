import 'package:flutter/material.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';


class ViewMyAppBar extends StatefulWidget {
  final bool isHome;

  const ViewMyAppBar({Key? key, required this.isHome}) : super(key: key);

  @override
  _ViewMyAppBarState createState() => _ViewMyAppBarState();
}

class _ViewMyAppBarState extends State<ViewMyAppBar> {
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
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
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
    final args = ModalRoute.of(context)!.settings.arguments as ProjectViewArgs;
    return AppBar(
      leading: !widget.isHome
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop({"reload": true});
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
         IconButton(
                    onPressed: () async {
                      dynamic response = await Navigator.pushNamed(
                        context,
                        '/project-builder',
                        arguments:
                            ProjectBuilderArgs(false, project: args.project),
                      );

                      if (response != null) {
                        if (response['reload'])
                          Navigator.of(context).pop({"reload": true});
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
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
