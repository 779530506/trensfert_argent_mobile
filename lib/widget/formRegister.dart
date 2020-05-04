import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:http/http.dart' as http;
import 'package:trensfert_argent_mobile/modele/role.dart';
import 'package:trensfert_argent_mobile/modele/user.dart';
class FormRegister extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}
class _FormRegisterState extends State<FormRegister> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  List<Map<String,dynamic>> roleList=[];
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final baseUrl ='http://10.0.2.2:8000/api';
  AuthService authService = AuthService();
 Future<User>   postUser(User user) async{
        String url='$baseUrl/users';
        var token = await  authService.getToken();
        print(user.dateNaissance);
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
            print(data.body);
          }
        ).catchError(
          (error){
            print(error);
          }
        );
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
                autovalidate: true,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'nom',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Nom",icon:Icon (Icons.person)),
                      ),
                      FormBuilderTextField(
                        attribute: 'prenom',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Prenom", icon:Icon (Icons.person)),
                      ),
                      FormBuilderTextField(
                        attribute: 'email',
                        validators: [FormBuilderValidators.required(), FormBuilderValidators.email()],
                        decoration: InputDecoration(icon:Icon (Icons.email),labelText: "Email"),
                      ),
                      FormBuilderTextField(
                        attribute: 'adresse',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Adresse",icon:Icon (Icons.location_on)),
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "dateNaissance",
                        inputType: InputType.date,
                        validators: [FormBuilderValidators.required()],
                        //format: DateFormat("dd-MM-yyyy"),
                        decoration: InputDecoration(labelText: "Date de naissance",icon:Icon (Icons.date_range)),
                      ),
                      FormBuilderDropdown(
                        attribute: "role",
                        decoration: InputDecoration(labelText: "Role"),
                        // initialValue: 'Male',
                        hint: Text('Selectinner le role'),
                        validators: [FormBuilderValidators.required()],
                        items: this.roleList
                            .map((role) => DropdownMenuItem(
                            value:"${role['id']}",
                            child: Text("${role['libelle']}")))
                            .toList(),
                      ),
                      FormBuilderTextField(
                        attribute: "telephon",
                        decoration: InputDecoration(labelText: "telphon",icon:Icon (Icons.call)),
                        validators: [
                          FormBuilderValidators.maxLength(15),
                          FormBuilderValidators.minLength(9)
                        ],
                      ),
                      FormBuilderCheckbox(
                        attribute: 'isActive',
                        label: Text(
                            "Status")
                      ),
                      FormBuilderTextField(
                        attribute: 'username',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Username",icon:Icon (Icons.person)),
                      ),
                      FormBuilderTextField(
                        attribute: 'password',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Password",icon:Icon (Icons.lock)),
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
                        onPressed: () {
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
                             postUser(user);
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