import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:http/http.dart' as http;
import 'package:trensfert_argent_mobile/modele/partenaire.dart';
import 'package:trensfert_argent_mobile/modele/user.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';
class CreerCompte extends StatefulWidget {
  @override
  _CreerCompteState createState() => _CreerCompteState();
}
class _CreerCompteState extends State<CreerCompte> {
  String message;
  List<Map<String,dynamic>> roleList=[];
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final baseUrl =Environnement().BASE_URL;
  AuthService authService = AuthService();
 postUser(User user, Partenaire partenaire,int solde) async{
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
            if(data.statusCode==201){
               var user =jsonDecode(data.body);
               partenaire.idUserPartenaire=user['@id'];
               this.postPartenaire(partenaire,solde,user['id']);
            }else{
              alert(context, "Erreur", "${this.message}");
            }
          }
        ).catchError(
          (error){
            print(error);
            alert(context, "Erreur", "Serveur inaccessible");
          }
        );
    }
  /*
   *idUser permet de suprimer l'utisateur si la crétion du partenaire à échoué 
   */
  postPartenaire(Partenaire partenaire, int solde, int idUser) async{
        String url='$baseUrl/partenaires';
        var token = await  authService.getToken();
      return  http.post(
            url,
            headers:  <String, String>{
                    'Content-Type': 'application/json',
                    HttpHeaders.authorizationHeader: "bearer $token"
                   },
           body: jsonEncode(<String,dynamic> {
             "ninea":partenaire.ninea,
             "registreDuCommerce": partenaire.registreDuCommerce,
             "userPartenaire":partenaire.idUserPartenaire
            })
        ).then(
          (data){
            var part = jsonDecode(data.body);
            this.message=(jsonDecode(data.body)['hydra:description']);
            if(data.statusCode == 201){
              this.postCompte(solde, part['@id'],part['id'],idUser);
            }else{
             this.deleteUser(idUser);
             alert(context, "Erreur:${data.statusCode}", "${this.message} "); 
            }
          }
        ).catchError(
          (error){
             this.deleteUser(idUser);
            print(error);
          }
        );
    }
  /*
   * partenaire est l'adresse du partenaire sous /api/partenaire/id
   * idPartenaire est id du partenaire
   */
  postCompte(solde,String partenaire,int idPartenaire,int idUser) async{
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
             "solde":solde,
             "partenaire": partenaire,

            })
        ).then(
          (data){
            var compte = jsonDecode(data.body);
            this.message=(jsonDecode(data.body)['hydra:description']);
            if(data.statusCode == 201){
              var numero = compte['numeroCompte'];       
              alert(context, "OK:${data.statusCode}", "compte créer avec succés \n numero : $numero");
              _fbKey.currentState.reset();
            }else{
              this.deletePartenaire(idPartenaire);
              this.deleteUser(idUser);
              alert(context, "Erreur", "${this.message}");
            }
          }
        ).catchError(
          (error){
            this.deletePartenaire(idPartenaire);
            this.deleteUser(idUser);
            alert(context, "Erreur", "Serveur inaccessible");
            print(error);
          }
        );
    }
  deleteUser(int id) async{
     String url='$baseUrl/users/$id';
        var token = await  authService.getToken();
         http.delete(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          );   
   }
  deletePartenaire(int id) async{
     String url='$baseUrl/partenaires/$id';
        var token = await  authService.getToken();
         http.delete(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
         );   
   }

   alert(context, String title,String content) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
        title: Text(title,style: TextStyle( fontWeight: FontWeight.bold,fontSize: 40),),
        content: Text(content, style: TextStyle(fontSize: 30),),
        actions: <Widget>[
          FlatButton(
            color: Colors.teal,
            child: Text('ok',style: TextStyle(fontSize: 25)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        )      
      );
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
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 22),
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
                        format: DateFormat("dd/MM/yyyy"),
                        decoration: InputDecoration(labelText: "Date de naissance",),
                      ),
                      FormBuilderDropdown(
                        attribute: "role",
                        decoration: InputDecoration(labelText: "Role"),
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
                            "Status")
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
                      FormBuilderTextField(
                        attribute: 'solde',
                        style: TextStyle(fontSize: 22),
                        keyboardType: TextInputType.number,
                        validators: [FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(500000),
                        FormBuilderValidators.max(2000000)
                        ],
                        decoration: InputDecoration(labelText: "Solde"),
                      ),
                      FormBuilderTextField(
                        attribute: 'ninea',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "ninea"),
                      ),
                      FormBuilderTextField(
                        attribute: 'registreDuCommerce',
                        style: TextStyle(fontSize: 22),
                        validators: [FormBuilderValidators.required()],
                        decoration: InputDecoration(labelText: "registreDuCommerce"),
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
                        child: Text("Submit",style: TextStyle(fontSize: 22,color: Colors.white70),),
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
                            Partenaire partenaire = new Partenaire(
                               ninea: _fbKey.currentState.value['ninea'],
                               registreDuCommerce: _fbKey.currentState.value['registreDuCommerce'],
                            ) ; 
                            var solde = int.parse(_fbKey.currentState.value['solde']);
                              this.postUser(user,partenaire,solde);  
                                          
                          }
                        },
                      ),
                    ),
                    MaterialButton(
                      child: Text("Reset",style: TextStyle(fontSize: 22,color: Colors.white70),),
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