import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/formConnexion.dart';
import 'package:trensfert_argent_mobile/widget/ajoutCompte.dart';
import 'package:trensfert_argent_mobile/widget/compteList.dart';
import 'package:trensfert_argent_mobile/widget/creerCompte.dart';
import 'package:trensfert_argent_mobile/widget/depot.dart';
import 'package:trensfert_argent_mobile/widget/formRegister.dart';
import 'package:trensfert_argent_mobile/widget/trensfert.dart';
import 'package:trensfert_argent_mobile/widget/userList.dart';
import 'package:trensfert_argent_mobile/widget/userView.dart';
    main() {
    runApp(MaterialApp(
        initialRoute: '/',
        routes: {
          '/accueil': (context) => Accueil(),
          '/userList': (context) => UserList(),
          '/userAdd': (context) => FormRegister(),
          '/creer_compte': (context) => CreerCompte(),
          '/ajout_compte': (context) => AjoutCompte(),
          '/compte_list': (context) => CompteList(),
          '/depot': (context) => Depot(),
          '/trensfert': (context) => Trensfert(),
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
        backgroundColor: Colors.deepOrange,
      ),
      body: FormConnexion(),
    );
     
  }
}