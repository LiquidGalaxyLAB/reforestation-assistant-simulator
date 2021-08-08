import 'package:flutter/material.dart';
import 'package:ras/@helpers/SeedIcons.dart';
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
  bool isLoaded = false;

  TextEditingController commonName = TextEditingController();
  TextEditingController scientificName = TextEditingController();
  TextEditingController co2PerYear = TextEditingController();
  TextEditingController germinativePot = TextEditingController();
  TextEditingController estimatedLong = TextEditingController();
  TextEditingController estimatedFHeight = TextEditingController();
  TextEditingController seedCost = TextEditingController();
  TextEditingController establishmentCost = TextEditingController();
  dynamic seedIcon = SeedIcons.list[0];

  showHelpDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('$title')),
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

  saveSeed(SeedFormArgs args) async {
    if (args.isNew) {
      Seed seed = Seed(
        '',
        commonName.text,
        scientificName.text,
        seedIcon,
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
        Navigator.of(context).pop({"reload": true});
      });
      response.catchError((onError) => print('Error $onError'));
    } else {
      Seed seed = Seed(
        args.seed!.id,
        commonName.text,
        scientificName.text,
        seedIcon,
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
        Navigator.of(context).pop({"reload": true});
      });
      response.catchError((onError) => print('Error $onError'));
    }
  }

  _selectSeed() {
    List iconSeeds = SeedIcons.list;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose Icon'),
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
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter alertState) {
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: ListView.builder(
                    itemCount: iconSeeds.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            iconSeeds[index]['url'],
                            scale: 1,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text('${iconSeeds[index]['name']}'),
                        onTap: () {
                          // select icon
                          setState(() {
                            seedIcon = {
                              "name": iconSeeds[index]['name'],
                              "url": iconSeeds[index]['url']
                            };
                          });

                          alertState(() {});
                          Navigator.pop(context);
                        },
                      );
                    }),
              );
            }),
          );
        });
  }

  _init(SeedFormArgs args) async {
    isLoaded = true;
    if (!args.isNew) {
      commonName.text = args.seed!.commonName;
      scientificName.text = args.seed!.scientificName;
      co2PerYear.text = args.seed!.co2PerYear.toString();
      germinativePot.text = args.seed!.germinativePotential.toString();
      estimatedLong.text = args.seed!.estimatedLongevity.toString();
      estimatedFHeight.text = args.seed!.estimatedFinalHeight.toString();
      seedCost.text = args.seed!.seedCost.toString();
      establishmentCost.text = args.seed!.establishmentCost.toString();
      seedIcon = args.seed!.icon;
    } else {
      co2PerYear.text = "0";
      germinativePot.text = "0";
      estimatedLong.text = "0";
      estimatedFHeight.text = "0";
      seedCost.text = "0";
      establishmentCost.text = "0";
      commonName.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SeedFormArgs;
    if (!isLoaded) _init(args);

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
                          showHelpDialog('Common Name',
                              'The common name of this plant in the region');
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
                          showHelpDialog('Scientific Name',
                              'The scientific name of this species');
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
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        seedIcon['url'],
                        scale: 1,
                        fit: BoxFit.fill,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15)),
                      child: Text(
                        'Select Icon',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        _selectSeed();
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          showHelpDialog('Icon',
                              'Icon that will be used to represent the seed both in the app\'s map and on Google Earth');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'CO2 capture (Number in tonnes)',
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
                          showHelpDialog('CO2 capture (Number in tonnes)',
                              'The total capture of CO2 after 40 years at the apogee of the live of the tree');
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
                          showHelpDialog('Germinative potential (%)',
                              'The tested germinative potential measured in the laboratory with optimal conditions');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Estimated longevity (number, years)',
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
                          showHelpDialog('Estimated longevity (number, years)',
                              'Estimated longevity of this species');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Estimated final height (number, meters)',
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
                              'Estimated final height (number, meters)',
                              'Estimated height of this species');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Seed cost per kg. (number, euros)',
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
                          showHelpDialog('Seed cost per kg. (number, euros)',
                              'Cost of 1 kg of seeds of this species');
                        },
                        icon: Icon(Icons.help))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                  child: Text(
                    'Establishment cost per plant. (number, euros)',
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
                          showHelpDialog(
                              'Establishment cost per plant. (number, euros)',
                              'Plant establishment cost (Still alive after 2 years after the sowing)');
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
                            } else {
                              print('ooppsss throw error');
                              showHelpDialog('Invalid fields!',
                                  'Some fields have invalid values or are required. Please check them again');
                            }
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
