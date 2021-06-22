import 'package:flutter/material.dart';
import 'package:ras/route-args/SeedFormArgs.dart';
import 'package:ras/widgets/AppBar.dart';

class SeedForm extends StatefulWidget {
  const SeedForm({Key? key}) : super(key: key);

  @override
  _SeedFormState createState() => _SeedFormState();
}

class _SeedFormState extends State<SeedForm> {
  final _formKey = GlobalKey<FormState>();

  showHelpDialog(String title, String msg) {
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
                  child: Text("CLOSE"),
                  onPressed: () {
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
    final args = ModalRoute.of(context)!.settings.arguments as SeedFormArgs;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(
          isHome: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 20.0, bottom: 20.0, right: 5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPECIES FORM',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Common Name*',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a common name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog(
                              'Common Name', 'Popular name, easy to remember');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Scientific Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('Scientific Name', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Icon',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/treeIcon.png',
                      scale: 1,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15)),
                      child: Text(
                        'UPLOAD FILE',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('Icon', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'CO2 capture per year',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('CO2 capture per year', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Germinative potential (%)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('Germinative potential (%)', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Estimated longevity (years)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog(
                              'Estimated longevity (years)', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Estimated final height (meters)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog(
                              'Estimated final height (meters)', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Seed cost (1kg)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('Seed cost (1kg)', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Establishment cost',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('Establishment cost', '.....');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 15)),
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print('validated!');
                            } else
                              print('ooppsss');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
