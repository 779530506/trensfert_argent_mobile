import 'dart:convert';
import 'dart:io';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/modele/user.dart';
import 'package:trensfert_argent_mobile/widget/userView.dart';
class EditUser extends StatefulWidget {
  int id;
  EditUser({this.id});
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
   List<Map<String,dynamic>> roleList=[];
   Map<String,dynamic> user;
   String message;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final baseUrl ='http://10.0.2.2:8000/api';
  AuthService authService = new AuthService();
  Future<int>   putUser(User user) async{
        String url='$baseUrl/users/${widget.id}';
        var token = await  authService.getToken();
      return  http.put(
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
             // "role":user.role,
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
 
    Future<bool> editUser(User user) async{
      var statusCode = await putUser(user);
      if(statusCode == null){
      //this.alert(context, 'erreur', "Serveur inaccessible");
      }else if(statusCode >= 400 && statusCode < 500 ){
        this.alert(context, 'Erreur', this.message);
       } else if(statusCode == 200){
              this.alert(context, 'OK', "user editer avec success",);
              return true;
        }
        else {
          this.alert(context, 'Erreur', '$statusCode');
        }
        return false;
      
    } 
  getRoles() async{
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
   getUser() async{
     String url='$baseUrl/users/${widget.id}';
        var token = await  authService.getToken();
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
              var user = json.decode(data.body);
              this.user = {
                'nom' : user['nom'],
                'prenom': user['prenom'],
                'adresse' : user['adresse'],
                'email': user['email'],
                'telephon' : user['telephon'],
                'dateNaissance':DateTime.parse(user['dateNaissance']),
                'isActive' : user['isActive'],
                'role': user['role'],
                'username' : user['username'],
              };
              print(this.user);
            });
         }
          ).catchError((error){
            print(error);
          });     
   }
  alert(context, String title,String content) =>
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
   @override
  void initState() {
    super.initState();
    this.getUser();
    //this.getRoles();

  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: Text("User edit"),
        backgroundColor: Colors.teal,
       ),
      body: this.user == null ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {
                'nom' : this.user['nom'],
                'prenom': this.user['prenom'],
                'adresse' : this.user['adresse'],
                'email': this.user['email'],
                'telephon' : this.user['telephon'],
                'dateNaissance': this.user['dateNaissance'],
                'isActive' : this.user['isActive'],
                'role': this.user['role'],
                'username' : this.user['username'],

                },
                autovalidate: false,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'nom',
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Nom"),
                      ),
                      FormBuilderTextField(
                        attribute: 'prenom',
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
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Adresse"),
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "dateNaissance",
                        inputType: InputType.date,
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Date de naissance",),
                      ),
                      // FormBuilderDropdown(
                      //   attribute: "role",
                      //   decoration: InputDecoration(labelText: "Role"),
                      //   hint: Text('Selectinner le role'),
                      //   validators: [FormBuilderValidators.required()],
                      //   items: this.roleList
                      //       .map((role) => DropdownMenuItem(
                      //       value:"${role['id']}",
                      //       child: Text("${role['libelle']}")))
                      //       .toList(),
                      // ),
                      FormBuilderTextField(
                        attribute: "telephon",
                        decoration: InputDecoration(labelText: "telphon"),
                        validators: [
                          FormBuilderValidators.maxLength(25),
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
                        validators: [FormBuilderValidators.maxLength(25),
                          FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                      FormBuilderTextField(
                        attribute: 'password',
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
                              //role: _fbKey.currentState.value['role'],
                              isActive : _fbKey.currentState.value['isActive'],
                              username: _fbKey.currentState.value['username'],
                              password: _fbKey.currentState.value['password'],
                              dateNaissance:_fbKey.currentState.value['dateNaissance']
                            );  
                            setState(() async{
                              var enregistrer = await this.editUser(user);  
                            if(enregistrer){
                             Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserView(id: widget.id)));
                            }
                            });                          
                                             
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