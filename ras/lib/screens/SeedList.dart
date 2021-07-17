import 'dart:io';

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
  bool isSearching = false;
  List<Seed> toBeFiltered = [];

  init() async {
    _listSeeds.then((value) {
      toBeFiltered = value;
    });
  }

  showDeleteDialog(String title, String msg, String id) {
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
                    // delete seed
                    Future response = SeedRepository().delete(id);
                    response.then((value) {
                      print('Success!!');
                    });
                    response.catchError((onError) => print('Error $onError'));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  void filterSearchResults(String query) {
    List<Seed> dummySearchList = [];
    dummySearchList.addAll(toBeFiltered);
    if (query.isNotEmpty) {
      List<Seed> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.commonName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        toBeFiltered.clear();
        toBeFiltered.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _listSeeds = SeedRepository().getAll();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Stack(
      children: [
        Column(
          children: [
            !isSearching
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Seeds',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _listSeeds = SeedRepository().getAll();
                                });
                              },
                              icon: Icon(Icons.refresh),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearching = true;
                                });
                              },
                              icon: Icon(Icons.search),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Search',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isSearching = false;
                              _listSeeds = SeedRepository().getAll();
                            });
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: FutureBuilder(
                  future: _listSeeds,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Seed> data = snapshot.data;

                      if (data.length <= 0)
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'No results',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );

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
                                          leading: data[index].icon != ''
                                              ? Container(
                                                  width: 60,
                                                  height: 60,
                                                  child: Image.file(
                                                    File(data[index].icon),
                                                    scale: 1,
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.legend_toggle_rounded),
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
                                              onPressed: () {
                                                showDeleteDialog(
                                                    'Are you sure?',
                                                    'This action can\'t be undone and you will be deleting your seed!',
                                                    data[index].id);
                                              },
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
                                  title:
                                      Text('€${data[index].seedCost} each 1kg'),
                                  subtitle: Text('Seed Cost (1kg)'),
                                ),
                                ListTile(
                                  title:
                                      Text('€${data[index].establishmentCost}'),
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
