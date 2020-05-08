import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:http/http.dart' as http;
import 'package:trensfert_argent_mobile/modele/role.dart';
import 'package:trensfert_argent_mobile/modele/user.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';
class AjoutCompte extends StatefulWidget {
  @override
  _AjoutCompteState createState() => _AjoutCompteState();
}
class _AjoutCompteState extends State<AjoutCompte> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool enregistrer = false;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final baseUrl =Environnement().BASE_URL;
  AuthService authService = AuthService();
  String ninea;
      postCompte(compte) async{
        String url='$baseUrl/comptes';
        var token = await  authService.getToken();
      return  http.post(
            url,
            headers:  <String, String>{
                    'Content-Type': 'application/json',
                    HttpHeaders.authorizationHeader: "bearer $token"
                   },
           body: 
            jsonEncode(<String,dynamic> {
             "solde":compte['solde'],
             "partenaire": compte['partenaire'],

            })
        ).then(
          (data){
            var compte = jsonDecode(data.body);
            print(compte['numeroCompte']);
            if(data.statusCode == 201){
              var numero = compte['numeroCompte'];       
              alert(context, "OK:${data.statusCode}", "compte créer avec succés \n numero : $numero");
             
            }
          }
        ).catchError(
          (error){
            print(error);
          }
        );
    }
  
   alert(context, String title,String content,) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
        title: Text(title,style: TextStyle( fontWeight: FontWeight.bold,fontSize: 30),),
        content: Text(content, style: TextStyle(fontSize: 25),),
        actions: <Widget>[
          FlatButton(
            color: Colors.teal,
            child: Text('ok',style: TextStyle(fontSize: 35)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        )      
      );
   }
  getPartenaireByNinea(String ninea, solde) async{
     String url='$baseUrl/partenaires/ninea/$ninea';
        var token = await  authService.getToken();
        print(ninea);
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
              if(data.statusCode==200){
                var partenaire = json.decode(data.body);
                print(partenaire);
                var id= "/api/partenaires/${partenaire["id"]}";
                var compte = {
                  'solde': solde,
                  'partenaire': id
                };
                this.postCompte(compte);
              }else{
                var message = json.decode(data.body);
                alert(context, "Erreur:${data.statusCode}", "${message['message']}");             
              }
              }
          ).catchError((error){
            print(error);
          });     
   }
 
   @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar (
        title: Text("Ajouter un compte"),
        backgroundColor: Colors.teal,
       ),
      body: SingleChildScrollView(
              child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(   
            children: <Widget>[
              Icon(Icons.computer, size: 150,color: Colors.lime,),
              FormBuilder(
                key: _fbKey,
                initialValue: {
                },
                autovalidate: false,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'solde',
                        style: TextStyle(fontSize: 25),
                        keyboardType: TextInputType.number,
                        validators: [FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(500000),
                        FormBuilderValidators.max(2000000)
                        ],
                        decoration: InputDecoration(labelText: "Solde",),
                      ),
                      FormBuilderTextField(
                        attribute: 'ninea',
                        style: TextStyle(fontSize: 25),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "ninea"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: RaisedButton(
                          child: Text("Submit",style: TextStyle(fontSize: 35,color: Colors.white70),),
                          color: Colors.teal,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              ),
                          onPressed: () async {
                            _fbKey.currentState.save();
                            if (_fbKey.currentState.validate()) {
                              var ninea =_fbKey.currentState.value["ninea"];
                              var  solde =int.parse(_fbKey.currentState.value["solde"]);
                              this.getPartenaireByNinea(ninea,solde); 
                               _fbKey.currentState.reset();
                            } 
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    
    );
  }
}