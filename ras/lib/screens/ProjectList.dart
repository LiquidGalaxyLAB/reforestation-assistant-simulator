import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';
import 'package:ras/route-args/ProjectViewArgs.dart';
import 'package:ras/services/Authentication.dart';
import 'package:ras/services/Drive.dart';
import 'package:permission_handler/permission_handler.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  Future<List<Project>> _listProjects = ProjectRepository().getAll();
  bool isSearching = false;
  List<Project> toBeFiltered = [];
  bool filterByNewest = false;
  bool filterByOldest = false;
  User? currentUser = Authentication.currentUser();

  init() async {
    _listProjects.then((value) {
      toBeFiltered = value;
    });
  }

  showAlertDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$title'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text('$msg'),
          );
        });
  }

  uploadToDrive(Project project) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      try {
        await GoogleDrive().requestPermission(project);
        showAlertDialog(
            'Success!', 'This project has been uploaded to Google Drive');
      } catch (e) {
        print(e);
        showAlertDialog('Error!',
            'An error occured while uploading to Google Drive. Please check if you have granted permissions to the app or try again later');
      }
    } else {
      var isGranted = await Permission.storage.request().isGranted;
      if (isGranted) {
        try {
          await GoogleDrive().requestPermission(project);
          showAlertDialog(
              'Success!', 'This project has been uploaded to Google Drive');
        } catch (e) {
          print(e);
          showAlertDialog('Error!',
              'An error occured while uploading to Google Drive. Please check if you have granted permissions to the app or try again later');
        }
      }
    }
  }

  duplicateProject(Project model) {
    Project project = Project(
      '',
      model.projectName,
      model.dateOfProject,
      model.sownMode,
      model.region,
      model.minSwtDate,
      model.maxSwtDate,
      model.minSwtTemp,
      model.maxSwtTemp,
      model.avgNumberOfRains,
      model.totalNumberOfRains,
      model.seeds,
      model.validSurface,
      model.notValidSurface,
      model.emptyLand,
      model.orientation,
      model.minAltTerrain,
      model.maxAltTerrain,
      model.maxDistance,
      model.depth,
      model.ph,
      model.fractured,
      model.hummus,
      model.inclination,
      model.geodata,
      model.minFlightHeight,
      model.predation,
      model.sizeOfDeposit,
      model.sizeOfSeedballs,
      model.areaCovered,
    );
    Future response = ProjectRepository().create(project);
    response.then((value) {
      print('Success!!!! $value');
      setState(() {
        _listProjects = ProjectRepository().getAll();
      });
    });
    response.catchError((onError) => print('Error $onError'));
  }

  filterSearchResults(String query) {
    List<Project> dummySearchList = [];
    dummySearchList.addAll(toBeFiltered);
    if (query.isNotEmpty) {
      List<Project> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.projectName.toLowerCase().contains(query.toLowerCase())) {
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
        _listProjects = ProjectRepository().getAll();
        filterByNewest = false;
        filterByOldest = false;
      });
    }
  }

  filterByAttributes() {
    List<Project> dummySearchList = [];
    dummySearchList.addAll(toBeFiltered);
    if (filterByOldest) {
      dummySearchList.sort((a, b) {
        return a.dateOfProject.compareTo(b.dateOfProject);
      });
      setState(() {
        toBeFiltered.clear();
        toBeFiltered.addAll(dummySearchList);
      });
    } else if (filterByNewest) {
      dummySearchList.sort((a, b) {
        return b.dateOfProject.compareTo(a.dateOfProject);
      });
      setState(() {
        toBeFiltered.clear();
        toBeFiltered.addAll(dummySearchList);
      });
    } else {
      setState(() {
        _listProjects = ProjectRepository().getAll();
      });
    }
  }

  void filterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter bottomState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CheckboxListTile(
                    title: Text('Newest'),
                    value: filterByNewest,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          filterByNewest = !filterByNewest;
                          if (value) filterByOldest = false;
                        }
                      });

                      bottomState(() {});
                    }),
                CheckboxListTile(
                    title: Text('Oldest'),
                    value: filterByOldest,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          filterByOldest = !filterByOldest;
                          if (value) filterByNewest = false;
                        }
                      });
                      bottomState(() {});
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        filterByAttributes();
                      },
                      child: Text('Search')),
                )
              ],
            );
          });
        });
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
                          'Projects',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearching = true;
                                });
                              },
                              icon: Icon(Icons.search),
                            ),
                            IconButton(
                              onPressed: () {
                                filterBottomSheet(context);
                              },
                              icon: Icon(Icons.filter_list),
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
                              _listProjects = ProjectRepository().getAll();
                            });
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: FutureBuilder(
                  future: _listProjects,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Project> data = snapshot.data;

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
                            return GestureDetector(
                              onTap: () async {
                                dynamic response = await Navigator.pushNamed(
                                    context, '/project-view',
                                    arguments: ProjectViewArgs(data[index]));

                                if (response != null) {
                                  if (response['reload']) {
                                    setState(() {
                                      _listProjects =
                                          ProjectRepository().getAll();
                                    });
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.green,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: ListTile(
                                    trailing: data[index].sownMode == 'By Drone'
                                        ? Image.asset(
                                            'assets/appIcons/drone.png',
                                            height: 30,
                                            width: 30,
                                          )
                                        : Image.asset(
                                            'assets/appIcons/seeds.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    title: Text(
                                      '${data[index].projectName}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Date: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  '${data[index].dateOfProject.toString().substring(0, 10)}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                           Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Area covered: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  '${data[index].areaCovered}m²',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Region: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  '${data[index].region}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Species sown: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                for (var i = 0;
                                                    i <
                                                        data[index]
                                                            .seeds
                                                            .length;
                                                    i++)
                                                  Text(
                                                    '${data[index].seeds[i].commonName} | density = ${data[index].seeds[i].density} plants per hectare',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              currentUser != null
                                                  ? OutlinedButton.icon(
                                                      onPressed: () {
                                                        uploadToDrive(
                                                            data[index]);
                                                      },
                                                      icon: Icon(
                                                          Icons.add_to_drive),
                                                      label: Text('Upload'),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        primary: Colors.blue,
                                                        side: BorderSide(
                                                            color: Colors.blue,
                                                            width: 1),
                                                      ),
                                                    )
                                                  : OutlinedButton.icon(
                                                      onPressed: () {
                                                        showAlertDialog(
                                                            'Please login',
                                                            'To work with Google Drive integration you need to login with Google. Go to Settings and click Sign In with Google');
                                                      },
                                                      icon: Icon(
                                                          Icons.add_to_drive),
                                                      label: Text('Upload'),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        primary: Colors.grey,
                                                        side: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1),
                                                      ),
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              OutlinedButton.icon(
                                                onPressed: () {
                                                  duplicateProject(data[index]);
                                                },
                                                icon: Icon(Icons.copy),
                                                label: Text('Duplicate'),
                                                style: OutlinedButton.styleFrom(
                                                  primary:
                                                      Colors.yellow.shade800,
                                                  side: BorderSide(
                                                      color: Colors
                                                          .yellow.shade800,
                                                      width: 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text(
                          'Sorry and error occurred. Error message: ${snapshot.error}');
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
                            child: Text('Loading data...',
                                style: TextStyle(color: Colors.grey)),
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
              onPressed: () async {
                dynamic response = await Navigator.pushNamed(
                    context, '/project-builder',
                    arguments: ProjectBuilderArgs(true));
                if (response != null) {
                  if (response['reload']) {
                    setState(() {
                      _listProjects = ProjectRepository().getAll();
                    });
                  }
                }
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
