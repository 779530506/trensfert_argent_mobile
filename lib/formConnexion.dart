import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/user.dart';
class FormConnexion extends StatefulWidget {
  @override
  _FormConnexionState createState() => _FormConnexionState();
}

class _FormConnexionState extends State<FormConnexion> {
      final _formKey = GlobalKey<FormState>();
    String _username ;
    String _password;
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
                   decoration: InputDecoration (

                     icon: Icon( Icons.person,size: 30),
                     labelText: "username",
                   ),
                    validator: (input) => input.isEmpty ?"ce champ est obligatoir":null,
                    onSaved: (input) => _username=input,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                   style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                   decoration: InputDecoration (
                     labelText: "password",
                     icon: Icon( Icons.lock,size: 30 ,),
                   ),
                   validator: (input) => input.length<4 ?"minimum 4 caractere":null,
                   onSaved: (input) => _password=input,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          ),
                    color: Colors.teal,
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        setState(() {
                         var user =AuthService().login(_username, _password);
                         print(user);
                   //   if( )
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Accueil()));
                        });

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