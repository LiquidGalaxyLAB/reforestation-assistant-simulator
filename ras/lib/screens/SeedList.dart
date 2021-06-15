import 'package:flutter/material.dart';
import 'package:ras/route-args/SeedFormArgs.dart';

class SeedList extends StatefulWidget {
  const SeedList({Key? key}) : super(key: key);

  @override
  _SeedListState createState() => _SeedListState();
}

class _SeedListState extends State<SeedList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text('Seed List'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, right: 30.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                print('New Seed');
                Navigator.pushNamed(context, '/seed-form', arguments: SeedFormArgs(true));
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
