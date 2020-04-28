import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/authService.dart';
class FormConnexion extends StatefulWidget {
  @override
  _FormConnexionState createState() => _FormConnexionState();
}

class _FormConnexionState extends State<FormConnexion> {
      final _formKey = GlobalKey<FormState>();
    String _username ;
    String _password;
    final TextEditingController _usernameController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();

    var auth = AuthService();
    SharedPreferences sharedPreferences;
 // Future<String> get tokenOrEmpty async {
//   var token = await storage.read(key: "token");
//   if(token == null) return "";
//   return token;
// }
  setToken(String token) async {
     sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences.setString('token', token);
    }
  Future<String> get tokenOrEmpty async{
    sharedPreferences = await SharedPreferences.getInstance();
     var token = await sharedPreferences.get('token') ?? 0;
     print(jsonDecode(token)['token']);
     if(token == null) return "";
       return token;

}
  @override
  Widget build(BuildContext context) {
    return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    controller: _usernameController,
                   decoration: InputDecoration (

                     icon: Icon( Icons.person,size: 30),
                     labelText: "username",
                   ),
                    validator: (input) => input.isEmpty ?"ce champ est obligatoir":null,
                    // onSaved: (input) => _username=input,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                   style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                   controller: _passwordController,
                   decoration: InputDecoration (
                     labelText: "password",
                     icon: Icon( Icons.lock,size: 30 ,),
                   ),
                   validator: (input) => input.length<4 ?"minimum 4 caractere":null,
                  //  onSaved: (input) => _password=input,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          ),
                    color: Colors.teal,
                onPressed: () async {
                  var username = _usernameController.text;
                  var password = _passwordController.text;
                 var token = await auth.attemptLogIn(username, password);
                 if(token != null) {
                   setToken(token);
                  // storage.write(key: "token", value: token);
                   
                 Navigator.push(
                      context,
                    MaterialPageRoute(
                   builder: (context) =>Accueil()
                    )
                   );
              }else{
                print('error');
              }
                }, 
                    child: Text(
                      'Se connecter',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25, color: Colors.black38),
                    ),
                  ),
                )
           ]
         ),
            )
      );
  
  }
}