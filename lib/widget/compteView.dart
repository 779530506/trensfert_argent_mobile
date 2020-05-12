import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';
import 'package:trensfert_argent_mobile/widget/compteList.dart';
class CompteView extends StatefulWidget {
  //@required
  int id;
  CompteView({this.id});
  @override
  _CompteViewState createState() => _CompteViewState();
}

class _CompteViewState extends State<CompteView> {
    var sharedPreferences ;
    Map <String,dynamic> compte;
    // String error;
     int id;
     final baseUrl =Environnement().BASE_URL;
    @override
    void initState() {
    super.initState();
    getCompte();
    this.id = widget.id;
  }
 getCompte() async{
     String url='$baseUrl/comptes/${widget.id}';
        var token = await  AuthService.getToken();
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
              compte = json.decode(data.body);
              print(compte);
            });
         }
          ).catchError((error){
            print(error);
          });    
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:AppBar(title: Text("Les détails du compte"),backgroundColor: Colors.deepOrange,),
     body: (compte == null ?
      Center(child: CircularProgressIndicator(),)
      :view()
    )
    );
  }
  view(){
  return 
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
       Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange,
             margin: EdgeInsets.fromLTRB(6,0,6,2),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Numéo du compte",
               style: TextStyle(fontSize: 18,color: Colors.white),),
             ),
             )
           ),
   
       ],),
     Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange[200],
             margin: EdgeInsets.all(6),
             child: Padding(
               padding: const EdgeInsets.all(20),
               child: Text("${this.compte['numeroCompte']},",
               style: TextStyle(fontSize: 20),),
             ),
             )
           ),
   
       ],),
      Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange,
             margin: EdgeInsets.fromLTRB(6,6,6,2),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Ninea du partenaire",
               style: TextStyle(fontSize: 18, color: Colors.white),),
             ),
             )
           ),
   
       ],),
     Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange[200],
             margin: EdgeInsets.all(6),
             child: Padding(
               padding: const EdgeInsets.all(20),
               child: Text("${this.compte['partenaire']['ninea']},",
               style: TextStyle(fontSize: 20),),
             ),
             )
           ),
   
       ],),
       Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange,
             margin: EdgeInsets.fromLTRB(6,6,6,2),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Date de création",
               style: TextStyle(fontSize: 18, color: Colors.white),),
             ),
             )
           ),
   
       ],),
     Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange[200],
             margin: EdgeInsets.all(6),
             child: Padding(
               padding: const EdgeInsets.all(20),
               child: Text("${DateFormat('dd/MM/yyyy:H:m').format(DateTime.parse(this.compte['createdDate']))}",
               style: TextStyle(fontSize: 20),),
             ),
             )
           ),
   
       ],),
        Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange,
             margin: EdgeInsets.fromLTRB(6,6,6,2),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Solde",
               style: TextStyle(fontSize: 18, color: Colors.white),),
             ),
             )
           ),
   
       ],),
     Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange[200],
             margin: EdgeInsets.all(6),
             child: Padding(
               padding: const EdgeInsets.all(20),
               child: Text("${this.compte['solde']}  Fcfa",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
             ),
             )
           ),
   
       ],),
          Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange,
             margin: EdgeInsets.fromLTRB(6,6,6,2),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Solde Initiale",
               style: TextStyle(fontSize: 18, color: Colors.white),),
             ),
             )
           ),
   
       ],),
     Row(
       children: <Widget>[
         Expanded(
           child: Card(
             color: Colors.deepOrange[200],
             margin: EdgeInsets.all(6),
             child: Padding(
               padding: const EdgeInsets.all(20),
               child: Text("${this.compte['soldeInitiale']}  Fcfa",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
             ),
             )
           ),
   
       ],),
    
    

  ],);
 
}
}
