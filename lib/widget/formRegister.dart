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
class FormRegister extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}
class _FormRegisterState extends State<FormRegister> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  String message;
  List<Map<String,dynamic>> roleList=[];
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final baseUrl =Environnement().BASE_URL;
  AuthService authService = AuthService();
 Future<int>   postUser(User user) async{
        String url='$baseUrl/users';
        var token = await  authService.getToken();
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
 alert(context, String title,String content) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
        title: Text(title,style: TextStyle( fontWeight: FontWeight.bold,fontSize: 40),),
        content: Text(content, style: TextStyle(fontSize: 35),),
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
 Future<bool> addUser(User user) async{
      var statusCode = await postUser(user);
      if(statusCode == null){
      this.alert(context, 'erreur', "Serveur inaccessible");
      }else if(statusCode >= 400 && statusCode < 500 ){
        this.alert(context, 'Erreur', this.message);
       } else if(statusCode == 201){
              this.alert(context, 'Success', "user enregistré avec success",);
              return true;
        }
        else {
          this.alert(context, 'Erreur', '$statusCode');
        }
        return false;
      
    } 
 getroles() async{
     String url='$baseUrl/roles';
        var token = await  authService.getToken();
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
              var roles = json.decode(data.body);
              roles=roles['hydra:member'];
              for(var role in roles){
                this.roleList.add( {
                  'id' : role['@id'],
                  'libelle':role['libelle']
                });
               
              }
            });
         }
          ).catchError((error){
            print(error);
          });     
   }
   @override
  void initState() {
    super.initState();
    getroles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar (
        title: Text("User register"),
        backgroundColor: Colors.teal,
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
                      FormBuilderDropdown(
                        attribute: "role",
                        // initialValue: 'Male',
                        hint: Text('Selectinner le role',style: TextStyle(fontSize: 22),),
                        validators: [FormBuilderValidators.required()],
                        items: this.roleList
                            .map((role) => DropdownMenuItem(
                            value:"${role['id']}",
                            child: Text("${role['libelle']}")))
                            .toList(),
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
                        color: Colors.teal,
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
                            var enregistrer = await this.addUser(user);  
                            if(enregistrer)
                              _fbKey.currentState.reset();                 
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