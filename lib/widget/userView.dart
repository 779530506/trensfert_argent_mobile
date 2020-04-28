import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/authService.dart';
class UserView extends StatefulWidget {
  //@required
  int id;
  UserView({this.id});
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
    var sharedPreferences ;
    var user;
     final baseUrl ='http://10.0.2.2:8000/api';
    AuthService authService = AuthService();
   getUser() async{
     String url='$baseUrl/users/${widget.id}';
        var token = await  authService.getToken();
        print(widget.id);
        print(token);
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
              user = json.decode(data.body);
              print(user);
            });
         }
          ).catchError((error){
            print(error);
          });     
   }
  @override
  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:AppBar(title: Text("Imformation personnelles"),backgroundColor: Colors.teal,),
     body: (user == null ?
      Center(child: CircularProgressIndicator(),)
      :view()
    )
    );
  }
  view(){
  return 
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Expanded(
      flex: 1,
          child: Card(
          color: Colors.transparent,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
             Expanded(
               flex: 4,
               child: Text('Username : ${user['username']}',
               style: TextStyle(fontSize: 20),
               )
               ),
            Expanded(
               flex: 3,
               child: Text(' nom : ${user['nom']}',
               style: TextStyle(fontSize: 20),
               )
               ),
            // Expanded(
            //    child: Text('${user['prenom']}')
            //    )   
             ],
             ),
          )
        ),
    )
  ,
  Expanded(
    flex: 1,
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
             Expanded(
               child: Text('Prenom : ${user['prenom']}',
               style: TextStyle(fontSize: 20),)
               ),
             ],
             ),
          )
        ),
  )
  ,
    Expanded(
    flex: 1,
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
            Expanded(
               child: Text(' email : ${user['email']}',
               style: TextStyle(fontSize: 20),)
               ),
             ],
             ),
          )
        ),
  )
  ,
    Expanded(
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
             Expanded(
               child: Text('tel : ${user['telephon']}',
               style: TextStyle(fontSize: 20),)
               ),
            Expanded(
               child: Text(' date de naisance : ${(user['dateNaissance'])}',
               style: TextStyle(fontSize: 20),)
               ),
            // Expanded(
            //    child: Text('${user['prenom']}')
            //    )   
             ],
             ),
          )
        ),
  )
,  Expanded(
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             //crossAxisAlignment: CrossAxisAlignment.baseline,
             children: <Widget>[
             Text('adresse : ${user['adresse']}',
             style: TextStyle(fontSize: 20),),
             ],
             ),
          )
        ),
  )
,
  Expanded(
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
             Expanded(
               flex: 2,
               child: Text('role : ${user['roles'][0]}',
               style: TextStyle(fontSize: 20),)
               ),
            Expanded(
               child: Text(' status : ${user['isActive']}',
               style: TextStyle(fontSize: 20),)
               ),
            // Expanded(
            //    child: Text('${user['prenom']}')
            //    )   
             ],
             ),
          )
        ),
  ),
  Expanded(
    child: Row(
      children: <Widget>[
         Expanded(
           child: IconButton(onPressed: (){

      },
      icon: Icon(
        Icons.delete,
        color: Colors.red,
        size: 42,
        ),
      ),
         ),
       Expanded(
          child: IconButton(onPressed: (){
      },
      icon: Icon(Icons.edit,
        color: Colors.teal,
        size: 42,
        ),
      ),
       ),
      
      ],
    ),
  )
  ],);
 
}
}
