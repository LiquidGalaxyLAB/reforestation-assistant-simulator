import 'package:flutter/material.dart';
import 'package:ras/models/Seed.dart';
import 'package:ras/repositories/Seed.dart';
import 'package:ras/route-args/SeedFormArgs.dart';
import 'package:ras/widgets/AppBar.dart';

class SeedForm extends StatefulWidget {
  const SeedForm({Key? key}) : super(key: key);

  @override
  _SeedFormState createState() => _SeedFormState();
}

class _SeedFormState extends State<SeedForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commonName = TextEditingController();
  TextEditingController scientificName = TextEditingController();
  TextEditingController co2PerYear = TextEditingController();
  TextEditingController germinativePot = TextEditingController();
  TextEditingController estimatedLong = TextEditingController();
  TextEditingController estimatedFHeight = TextEditingController();
  TextEditingController seedCost = TextEditingController();
  TextEditingController establishmentCost = TextEditingController();
  // ADD ICON

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

  saveSeed(SeedFormArgs args) async {
    if (args.isNew) {
      Seed seed = Seed(
        '',
        commonName.text,
        scientificName.text,
        'urlicon',
        double.parse(co2PerYear.text),
        double.parse(germinativePot.text),
        int.parse(estimatedLong.text),
        double.parse(estimatedFHeight.text),
        double.parse(seedCost.text),
        double.parse(establishmentCost.text),
      );
      Future response = SeedRepository().create(seed);
      response.then((value) {
        print('Success!!!! $value');
        Navigator.of(context).pop();
      });
      response.catchError((onError) => print('Error $onError'));
    } else {
      Seed seed = Seed(
        args.seed!.id,
        commonName.text,
        scientificName.text,
        'urlicon',
        double.parse(co2PerYear.text),
        double.parse(germinativePot.text),
        int.parse(estimatedLong.text),
        double.parse(estimatedFHeight.text),
        double.parse(seedCost.text),
        double.parse(establishmentCost.text),
      );
      Future response = SeedRepository().update(seed, seed.id);
      response.then((value) {
        print('Success! Seed updated');
        Navigator.of(context).pop();
      });
      response.catchError((onError) => print('Error $onError'));
    }
  }

  _init(SeedFormArgs args) {
    if (!args.isNew) {
      commonName.text = args.seed!.commonName;
      scientificName.text = args.seed!.scientificName;
      co2PerYear.text = args.seed!.co2PerYear.toString();
      germinativePot.text = args.seed!.germinativePotential.toString();
      estimatedLong.text = args.seed!.estimatedLongevity.toString();
      estimatedFHeight.text = args.seed!.estimatedFinalHeight.toString();
      seedCost.text = args.seed!.seedCost.toString();
      establishmentCost.text = args.seed!.establishmentCost.toString();
      // icon
    } else {
      co2PerYear.text = "0";
      germinativePot.text = "0";
      estimatedLong.text = "0";
      estimatedFHeight.text = "0";
      seedCost.text = "0";
      establishmentCost.text = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SeedFormArgs;
    _init(args);

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
                        controller: commonName,
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
                        controller: scientificName,
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
                        controller: co2PerYear,
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
                        controller: germinativePot,
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
                        controller: estimatedLong,
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
                        controller: estimatedFHeight,
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
                        controller: seedCost,
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
                        controller: establishmentCost,
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
                              saveSeed(args);
                            } else
                              print('ooppsss throw error');
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
