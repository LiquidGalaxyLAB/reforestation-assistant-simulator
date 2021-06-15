import 'package:flutter/material.dart';
import 'package:ras/widgets/AppBar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: MyAppBar(isHome: false,),
        ),
        body: Center(child: Text('About Screen'),),
    );
  }
}