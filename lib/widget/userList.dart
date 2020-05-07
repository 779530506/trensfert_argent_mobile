import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trensfert_argent_mobile/widget/userView.dart';


class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  var sharedPreferences ;
    var users=[];
    int currentPage=1;
    int size=7;
    int totalPage;
    int usersLength;
     ScrollController _scrollController = new ScrollController();
     final baseUrl ='http://10.0.2.2:8000/api';
    AuthService authService = AuthService();
   getUsers() async{
     String url='$baseUrl/users?page=$currentPage';
        var token = await  authService.getToken();
        print(token);
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
             var users = json.decode(data.body);
            usersLength = users['hydra:totalItems'];
             users = users['hydra:member'];
             for(var user in users){
                 this.users.add(user);
             }
            
             print(this.users);
             
              if(usersLength % size == 0)
              totalPage = usersLength ~/ size;
              else
              totalPage = (usersLength/size).floor();
              print(totalPage);
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
     _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        if(currentPage<totalPage){
        ++currentPage;
        this.getUsers();
        }

      }
    });
  }
   @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Les utilisateurs"),backgroundColor: Colors.teal,),
      //drawer: Menu(),
      body: (this.users == null ?
      Center(child: CircularProgressIndicator(),)
      :ListView.builder(
        controller: _scrollController,
        itemCount: (users==null ? 0 : users.length),
        itemBuilder: (context, index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                        child:Icon(
                          Icons.visibility,
                          size: 30,
                          color: Colors.lime
                          ),
                        onPressed: (){
                           var id = this.users[index]['id'];
                           Navigator.push(
                      context,
                     MaterialPageRoute(
                         builder: (context) =>UserView(id: id,),
                      )
                     );
                        },
                    ),
                  ),
                    Text("${this.users[index]['username']}", style: TextStyle(fontSize: 20),),
                ],
                ),
            ),
          );
        },
        )
      ),
    );
  }
}