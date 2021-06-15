import 'package:flutter/material.dart';
import 'package:ras/route-args/SeedFormArgs.dart';
import 'package:ras/widgets/AppBar.dart';

class SeedForm extends StatefulWidget {

  const SeedForm({Key? key}) : super(key: key);

  @override
  _SeedFormState createState() => _SeedFormState();
}

class _SeedFormState extends State<SeedForm> {
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
      body: Center(
        child: Text('Seed Form: New = ${args.isNew}'),
      ),
    );
  }
}
