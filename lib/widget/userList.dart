import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/menu.dart';
import 'package:trensfert_argent_mobile/service/userService.dart';
import '../modele/user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
    var users;
     final baseUrl ='http://10.0.2.2:8000/api';
   getUsers(){
     String url='$baseUrl/users';
     http.get(url).then(
       (data){
         setState(() {
           users = json.decode(data.body);
         });
       }
     ).catchError((error){
       print(error);
     });
     
   }
  @override
  void initState() {
    super.initState();
    getUsers();
    print(users);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Les utilisateurs"),backgroundColor: Colors.teal,),
      drawer: Menu(),
      body: (users == null ?
      Center(child: CircularProgressIndicator(),)
      :ListView.builder(
        itemCount: (users==null ? 0 : users.length),
        itemBuilder: (context, index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    // Card(
                    //   child:Text('username',style: TextStyle(fontSize: 22)) ,
                    //   color: Colors.teal,
                    //   ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: FlatButton(
                        child:Icon(Icons.edit),
                       // color: Colors.blueGrey,
                        onPressed: (){},
                    ),
                  ),
                    Text("${users['hydra:member'][index]['username']}", style: TextStyle(fontSize: 22),)
                ],
                ),
            )
          );
        },
        )
      ),
    );
  }
}