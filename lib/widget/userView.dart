import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/accueil.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';
import 'package:trensfert_argent_mobile/widget/editUser.dart';
import 'package:trensfert_argent_mobile/widget/userList.dart';
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
    String error;
    int id;
     final baseUrl =Environnement().BASE_URL;
    AuthService authService = AuthService();
    @override
    void initState() {
    super.initState();
    getUser();
    this.id = widget.id;
  }
  setStatus(int id) async{
       String url='$baseUrl/users/status/$id';
        var token = await  authService.getToken();
         http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
              if(data.statusCode==200){
                this.alert(context,'Ok', 'Status changé avec succés');
                }
                else this.alert(context,'Erreur','${data.statusCode}');
         }
          ).catchError((error){
            print(error);
            this.alert(context,'Erreur', 'Serveur Innaccessible');
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
              user = json.decode(data.body);
              print(user);
            });
         }
          ).catchError((error){
            print(error);
          });    
   }
  deleteUser() async{
     String url='$baseUrl/users/${widget.id}';
        var token = await  authService.getToken();
         http.delete(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
              if(data.statusCode==204){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Accueil()));
                this.alert(context,'OK : code ${data.statusCode}', 'user supprimé avec succés');
                //return true;
                }else{
                    this.alert(context,'Erreur: ${data.statusCode} ', ' impossible de supprimer');
                }
                
         }
          ).catchError((error){
            print(error);
            this.alert(context,'Erreur', 'Serveur Innaccessible');
          });   
      return false;    
   }
   alert(context, String title,String content) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
        title: Text(title,style: TextStyle(fontSize: 34),),
        content: Text(content,style:TextStyle(fontSize: 25),),
        actions: <Widget>[
          FlatButton(
            child: Text('Submit',style:TextStyle(fontSize: 25),),
            color: Colors.lime,
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Accueil()));
            },
          ),
        ],
        )

        
      );

   isActive(){
     if(user['isActive'])
     return Icon(Icons.lock_open, color: Colors.green, size: 30,);
     return Icon(Icons.lock, color: Colors.red, size: 30);
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
          color: Colors.lime,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
             Expanded(
               flex: 5,
               child: Text('Username : ${user['username']}',
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
               )
               ),
            Expanded(
               flex: 3,
               child: Text(' nom : ${user['nom']}',
               style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
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
  ),
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
               child: Text('${user['roles'][0]}',
               style: TextStyle(fontSize: 20),)
               ),
             ],
             ),
          )
        ),
  ),
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
               child: ListTile(
                 leading:Icon(Icons.email,
                 color: Colors.lime,
                  size: 25,
                 ) ,
                 title: Text('${user['email']}',
                       style: TextStyle(fontSize: 20),),
               )
               ),
             ],
             ),
          )
        ),
  )
  ,    Expanded(
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(    
            // mainAxisAlignment: MainAxisAlignment.center,
             //crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
            Expanded( 
              child: ListTile(
                 leading:Icon(
                  Icons.date_range,
                  color: Colors.lime,
                  size: 25,
                 ) ,
                 title: Text('${DateFormat('dd/MM/yyyy').format(DateTime.parse(user['dateNaissance']))}',
                       style: TextStyle(fontSize: 20),),
               ) 
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
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(    
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
             children: <Widget>[
             Expanded(
               child: ListTile(
                 leading:Icon(
                  Icons.call,
                  color: Colors.lime,
                  size: 25,
                 ) ,
                 title: Text('${user['telephon']}',
                       style: TextStyle(fontSize: 20),),
               )
               ),
             ],
             ),
          )
        ),
  ),
  Expanded(
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(    
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
             children: <Widget>[
             Expanded(
               child: ListTile(
                 leading:Icon(
                  Icons.location_on,
                  color: Colors.lime,
                  size: 25,
                 ) ,
                 title: Text('${user['adresse']}',
                       style: TextStyle(fontSize: 18),),
               )
               ),
             ],
             ),
          )
        ),
  ),
    Expanded(
      child: Card(
          color: Colors.white,
          child: 
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(    
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
             children: <Widget>[
             Expanded(
               child: ListTile(
                title: Text('Status',
                      style: TextStyle(fontSize: 20),),             
                 leading:isActive() ,
               )
               ),
             ],
             ),
          )
        ),
  ),
  Expanded(
    child: Row(
      children: <Widget>[
         Expanded(
           child: IconButton(
             onPressed: (){
               setState(()async {
                 var delete= await this.deleteUser();
                if(delete){
                  //this.alert(context,'suppression', 'suppression avec succés');
                 //Navigator.push(context, MaterialPageRoute(builder: (context)=>Accueil()));
                }else{
                 // this.alert(context,'suppression', 'Impossible de supprimer cet utilisateur');         
                }
               });

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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditUser(id: widget.id)));
      },
      icon: Icon(Icons.edit,
        color: Colors.teal,
        size: 42,
        ),
      ),
       ),
    Expanded(
          child: IconButton(onPressed: () async{
           this.setStatus(this.id);
            setState(()  {
              getUser();
            });
      },
      icon: Icon(Icons.control_point_duplicate,
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
