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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SPECIES TABLE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _listSeeds = SeedRepository().getAll();
                        });
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Refresh Table')),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _listSeeds,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Seed> data = snapshot.data;
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              title: Text('${data[index].commonName}'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading:
                                              Icon(Icons.legend_toggle_rounded),
                                          title: Text('Seed Icon'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/seed-form',
                                                    arguments: SeedFormArgs(
                                                        false,
                                                        seed: data[index]));
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Text('${data[index].commonName}'),
                                  subtitle: Text('Common name'),
                                ),
                                ListTile(
                                  title: Text('${data[index].scientificName}'),
                                  subtitle: Text('Scientific name'),
                                ),
                                ListTile(
                                  title: Text('${data[index].co2PerYear}'),
                                  subtitle: Text('CO2 capture per year'),
                                ),
                                ListTile(
                                  title: Text(
                                      '${data[index].germinativePotential}%'),
                                  subtitle: Text('Germinative potential (%)'),
                                ),
                                ListTile(
                                  title: Text(
                                      '${data[index].estimatedLongevity} years'),
                                  subtitle: Text('Estimated longevity (years)'),
                                ),
                                ListTile(
                                  title: Text(
                                      '${data[index].estimatedFinalHeight}m'),
                                  subtitle:
                                      Text('Estimated final height (meters)'),
                                ),
                                ListTile(
                                  title: Text(
                                      '\$${data[index].seedCost} each 1kg'),
                                  subtitle: Text('Seed Cost (1kg)'),
                                ),
                                ListTile(
                                  title: Text(
                                      '\$${data[index].establishmentCost}'),
                                  subtitle: Text('Establishment cost'),
                                ),
                              ],
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
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
                            child: Text('Loading data...'),
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
