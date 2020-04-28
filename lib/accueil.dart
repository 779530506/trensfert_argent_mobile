import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/menu.dart';
class Accueil extends StatefulWidget {
  String token;
  Accueil({this.token});
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Bokicas"),backgroundColor: Colors.teal,),
      drawer: Menu(),
      body: Center(child: Text("hello")),
    );
  }
}