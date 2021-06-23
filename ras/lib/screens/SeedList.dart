import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/repositories/Seed.dart';
import 'package:ras/route-args/SeedFormArgs.dart';

class SeedList extends StatefulWidget {
  const SeedList({Key? key}) : super(key: key);

  @override
  _SeedListState createState() => _SeedListState();
}

class _SeedListState extends State<SeedList> {
  Future<List<Seed>> _listSeeds = SeedRepository().getAll();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _listSeeds = SeedRepository().getAll();
                  });
                },
                icon: Icon(Icons.refresh),
                label: Text('Refresh Table')),
            Container(
              height: 600,
              child: FutureBuilder(
                  future: _listSeeds,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('${snapshot.data[index].commonName}'),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('Error ${snapshot.error}');
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                          )
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, right: 30.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                print('New Seed');
                Navigator.pushNamed(context, '/seed-form',
                    arguments: SeedFormArgs(true));
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
