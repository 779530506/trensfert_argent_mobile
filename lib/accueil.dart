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
      appBar:AppBar(title: Text("Bokicas"),backgroundColor: Colors.deepOrange,),
      drawer: Menu(),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
             new Stack(
              children: <Widget>[
                new Container(
                  height: 160,
                  width: 260,
                  child: Center(child: Icon(Icons.account_balance,size: 120,),),
                )
              ],
            ),
       new Stack(
              children: <Widget>[
                new Container(
                  height: 160,
                  width: 320,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(50),
                    color: Colors.black12
                  ),
                  child: Center(child: Text("BokiCash",style: TextStyle(fontSize: 65),)),
                )
              ],
            ),
             new Stack(
              children: <Widget>[
                new Container(
                  height: 160,
                  width: 370,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(50),
                   // color: Colors.black12
                  ),
                  child: Center(child: Text("Bienvenue !",style: TextStyle(fontSize: 65,
                  color: Colors.deepOrange,fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),)),
                )
              ],
            )
          ],
          )
        ),
    );
  }
}