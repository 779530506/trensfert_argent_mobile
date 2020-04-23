import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/formConnexion.dart';
    main() {
    runApp(MaterialApp(home: MyApp()));
  } 

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
      appBar:AppBar (
        title: Text("BokiCash"),
        backgroundColor: Colors.teal,
      ),
      body: FormConnexion(),
    );
     
  }
}