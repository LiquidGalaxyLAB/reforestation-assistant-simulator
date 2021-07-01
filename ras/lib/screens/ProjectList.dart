import 'package:flutter/material.dart';
import 'package:ras/models/Project.dart';
import 'package:ras/repositories/Project.dart';
import 'package:ras/route-args/ProjectBuilderArgs.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  Future<List<Project>> _listProjects = ProjectRepository().getAll();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // ElevatedButton(
            //   child: Text('DEMO TESTS'),
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/test');
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROJECTS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _listProjects = ProjectRepository().getAll();
                        });
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Refresh Table')),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _listProjects,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Project> data = snapshot.data;
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border(left: BorderSide(color: Colors.green, width: 10))
                              ),
                              child: ListTile(
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
                                          padding:
                                              const EdgeInsets.only(bottom: 5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Area covered: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '${data[index].maxDistance}m',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Date: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '${data[index].dateOfProject}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Region: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '${data[index].region}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Species sown: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              for (var i = 0;
                                                  i < data[index].seeds.length;
                                                  i++)
                                                Text(
                                                  '${data[index].seeds[i].commonName} | density = XX%',
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () {},
                                              icon: Icon(Icons.copy),
                                              label: Text('Duplicate'),
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.blue,
                                                side: BorderSide(
                                                    color: Colors.blue, width: 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                Navigator.pushNamed(context, '/project-builder',
                    arguments: ProjectBuilderArgs(true));
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
