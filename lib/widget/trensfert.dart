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
import 'package:trensfert_argent_mobile/widget/Alert.dart';
class Trensfert extends StatefulWidget {
  @override
  _TrensfertState createState() => _TrensfertState();
}
class _TrensfertState extends State<Trensfert> {
  String message;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final baseUrl =Environnement().BASE_URL;
 Future<int>   postUser(User user) async{
        String url='$baseUrl/users';
        var token = await  AuthService.getToken();
      return  http.post(
            url,
            headers:  <String, String>{
                    'Content-Type': 'application/json',
                    HttpHeaders.authorizationHeader: "bearer $token"
                   },
           body: 
            jsonEncode(<String,dynamic> {
             "nom":user.nom,
             "username": user.username,
              "password": user.password,
              "prenom":user.prenom,
             "email": user.email,
              "adresse": user.adresse,
              "role":user.role,
             "isActive": user.isActive,
              "dateNaissance": user.dateNaissance.toIso8601String(),
              "telephon": user.telephon
            })
        ).then(
          (data){
            this.message=(jsonDecode(data.body)['hydra:description']);
            return data.statusCode;
          }
        ).catchError(
          (error){
            print(error);
          }
        );
    }
  Future<bool> addUser(User user) async{
      var statusCode = await postUser(user);
      if(statusCode == null){
      AlertMessage.alert(context, 'erreur', "Serveur inaccessible");
      }else if(statusCode >= 400 && statusCode < 500 ){
        AlertMessage.alert(context, 'Erreur', this.message);
       } else if(statusCode == 201){
              AlertMessage.alert(context, 'Success', "user enregistré avec success",);
              return true;
        }
        else {
          AlertMessage.alert(context, 'Erreur', '$statusCode');
        }
        return false;
      
    } 
    @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar (
        title: Text("User register"),
        backgroundColor: Colors.deepOrange,
       ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'isActive': true,
                },
                autovalidate: false,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'nom',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Nom"),
                      ),
                      FormBuilderTextField(
                        attribute: 'prenom',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Prenom",),
                      ),
                      FormBuilderTextField(
                        attribute: 'email',
                        validators: [FormBuilderValidators.required(), FormBuilderValidators.email()],
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      FormBuilderTextField(
                        attribute: 'adresse',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Adresse"),
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "dateNaissance",
                        style: TextStyle(fontSize: 22),
                        inputType: InputType.date,
                        validators: [FormBuilderValidators.required()],
                        //format: DateFormat("dd-MM-yyyy"),
                        decoration: InputDecoration(labelText: "Date de naissance",),
                      ),
                      FormBuilderTextField(
                        attribute: "telephon",
                        style: TextStyle(fontSize: 22),
                        decoration: InputDecoration(labelText: "telphon"),
                        validators: [
                          FormBuilderValidators.maxLength(15),
                          FormBuilderValidators.minLength(9)
                        ],
                      ),
                      FormBuilderCheckbox(
                        attribute: 'isActive',
                        label: Text(
                            "Status",style: TextStyle(fontSize: 22),)
                      ),
                      FormBuilderTextField(
                        attribute: 'username',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                      FormBuilderTextField(
                        attribute: 'password',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Password"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Submit",style: TextStyle(fontSize: 22,color: Colors.white54),),
                        color: Colors.deepOrange,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            ),
                        onPressed: () async {
                          _fbKey.currentState.save();
                          if (_fbKey.currentState.validate()) {
                            print( _fbKey.currentState.value['dateNaissance']);
                            User user = new User(
                              nom: _fbKey.currentState.value['nom'],
                              prenom: _fbKey.currentState.value['prenom'],
                              adresse: _fbKey.currentState.value['adresse'],
                              email: _fbKey.currentState.value['email'],
                              telephon: _fbKey.currentState.value['telephon'],
                              role: _fbKey.currentState.value['role'],
                              isActive : _fbKey.currentState.value['isActive'],
                              username: _fbKey.currentState.value['username'],
                              password: _fbKey.currentState.value['password'],
                              dateNaissance:_fbKey.currentState.value['dateNaissance']
                            );                            
                            // var enregistrer = await this.addUser(user);  
                            // if(enregistrer)
                            //   _fbKey.currentState.reset();                 
                          }
                        },
                      ),
                    ),
                    MaterialButton(
                      child: Text("Reset",style: TextStyle(fontSize: 22,color: Colors.white54),),
                      color: Colors.black45,
                      shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            ),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
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