import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';
import 'package:trensfert_argent_mobile/widget/Alert.dart';
import 'package:trensfert_argent_mobile/widget/compteList.dart';
class CompteDepot extends StatefulWidget {
  //@required
  int id;
  CompteDepot({this.id});
  @override
  _CompteDepotState createState() => _CompteDepotState();
}

class _CompteDepotState extends State<CompteDepot> {
    var sharedPreferences ;
    Map <String,dynamic> compte;
     String message;
     final baseUrl =Environnement().BASE_URL;
    final TextEditingController montant = TextEditingController();
    @override
    void initState() {
    super.initState();
    getCompte();
  }
   postDepot(int montant,String compte) async{
     print(montant);
        String url='$baseUrl/depots';
        var token = await  AuthService.getToken();
      return  http.post(
            url,
            headers:  <String, String>{
                    'Content-Type': 'application/json',
                    HttpHeaders.authorizationHeader: "bearer $token"
                   },
           body: 
            jsonEncode(<String,dynamic> {
             "montant":montant,
             "compte": compte,

            })
        ).then(
          (data){
            this.message=(jsonDecode(data.body)['hydra:description']);
            if(data.statusCode == 201){
              AlertMessage.alert(context, "OK:${data.statusCode}", "votre depot de $montant est fait avec succés");
              this.getCompte();
            }else{
              AlertMessage.alert(context, "Erreur", "${this.message}");
            }
          }
        ).catchError(
          (error){
            AlertMessage.alert(context, "Erreur", "Serveur inaccessible");
            print(error);
          }
        );
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
  SingleChildScrollView(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0,5,5,30),
            child: Row(
         children: <Widget>[
             Expanded(
               flex: 3,
               child: Card(
                // color: Colors.,
                 margin: EdgeInsets.fromLTRB(15,10,1,0),
                 child: TextFormField(
                   controller: montant,
                     decoration: InputDecoration(
                       labelText: 'montant'
                     ),
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                 )
               ),
              
               //detail()
         ],),
          ),
           Row(
         children: <Widget>[
            Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15,0,15,25),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          ),
                  onPressed: (){
                    setState(() {
                      RegExp re = new RegExp(r"^[0-9]{5,7}$");
                      if(re.hasMatch(montant.text)){
                       postDepot(int.parse(montant.text),this.compte['@id']);
                       this.montant.clear();
                       
                      }else{
                        AlertMessage.alert(context, 'Erreur', 'données incorrecte');
                      }
                    });
                  },
                  color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Depot',style: TextStyle(fontSize: 25,color: Colors.white),),
                  )
                 
                  ),
              ),
            ),
         ],),
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
                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
               ),
               )
             ),
     
         ],),

    ],),
  );
 
}
}
