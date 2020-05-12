import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';
import 'package:trensfert_argent_mobile/widget/Alert.dart';
import 'package:trensfert_argent_mobile/widget/compteDepot.dart';
import 'package:trensfert_argent_mobile/widget/compteView.dart';
class Depot extends StatefulWidget {
  @override
  _DepotState createState() => _DepotState();
}

class _DepotState extends State<Depot> {
    var sharedPreferences ;
    Map <String,dynamic> compte;
    final TextEditingController numeroController = TextEditingController();
    // String error;
     int id;
     final baseUrl =Environnement().BASE_URL;
    @override
    void initState() {
    super.initState();
  }
   getCompte(String numeroCompte) async{
     String url='$baseUrl/comptes?numeroCompte=$numeroCompte';
        var token = await  AuthService.getToken();
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
              this.compte = json.decode(data.body);
              if(compte['hydra:member'].length != 0){
                this.compte = compte['hydra:member'][0];
                  Navigator.push(
                            context,
                                MaterialPageRoute(
                                    builder: (context) =>CompteDepot(id:this.compte['id'],),
                              )
                            );
              print(this.compte);
              }
              else
              AlertMessage.alert(context, 'Erreur', "ce compte n'existe pas");
            });
         }
          ).catchError((error){
            print(error);
          });    
   }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:AppBar(title: Text("Faire un dépot"),backgroundColor: Colors.deepOrange,),
     body:form()
    );
  }
  form(){
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
           flex: 4,
           child: Card(
             color: Colors.deepOrange[50],
             margin: EdgeInsets.fromLTRB(15,10,1,0),
             child: TextFormField(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  controller: numeroController ,
                )
             )
           ),
           Expanded(
           child: Padding(
             padding: const EdgeInsets.fromLTRB(0,10,5,0),
             child: RaisedButton(
               onPressed: (){
                 setState(() {
                   RegExp re = new RegExp(r"^(ncp-)[0-9]{5}$",caseSensitive: false);
                   if(re.hasMatch(numeroController.text))
                    getCompte(numeroController.text);
                    else
                    AlertMessage.alert(context, 'Erreur', 'Données incorrectes \n numéro compte doit etre sous forme \n ncp-XXXXX \n X un chiffre');
                 });
               
               },
               color: Colors.deepOrange,
               child: Icon(Icons.search,size: 50,color: Colors.white)
              
               ),
           )
           ),
           //detail()
       ],),
    ],);
 
}
 


}
