import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/formConnexion.dart';
import 'package:trensfert_argent_mobile/widget/formRegister.dart';
import 'package:trensfert_argent_mobile/widget/userList.dart';
import 'package:trensfert_argent_mobile/widget/userView.dart';
    main() {
    runApp(MaterialApp(
        initialRoute: '/',
        routes: {
          '/accueil': (context) => Accueil(),
          '/userList': (context) => UserList(),
          '/userAdd': (context) => FormRegister(),
          },
      home: MyApp()));
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