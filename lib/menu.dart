import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/main.dart';
import 'package:trensfert_argent_mobile/widget/userList.dart';
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
       children: <Widget>[
       DrawerHeader(
         decoration:BoxDecoration(
           gradient: LinearGradient(
             colors: [Colors.teal, Colors.green]
             ) ,
           ),
         child: Center(
           child: Text('gestion', 
           style: TextStyle(fontSize: 45),
           )) 
       ),
       ListTile(
                leading: Icon(
                  Icons.group
                 ) ,
                title: Text('User',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/userList');
                },
              ), 
        ListTile(
                leading: Icon(
                  Icons.person_add
                 ) ,
                title: Text('Add User',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/userAdd');
                },
              ),   
       Divider(color: Colors.black54,),
       ListTile(
                leading: Icon(
                  Icons.add_circle
                ) ,
                title: Text('Creation Compte',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),    
       ListTile(
                leading: Icon(
                  Icons.add_circle_outline
                ),
                title: Text('Ajout Compte',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ), 
       ListTile(
                leading: Icon(
                  Icons.list
                ) ,
                title: Text('liste Comptes',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),
       Divider(color: Colors.black54,),
       ListTile(
                leading: Icon(
                  Icons.monetization_on
                ) ,
                title: Text('Dépot',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),
       Divider(color: Colors.black54,),
       ListTile(
               leading: Icon(
                  Icons.send
                ) ,
                title: Text('Trensfert',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),  
       ListTile(
                leading: Icon(
                  Icons.attach_money
                ) ,
                title: Text('Retrait',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),   
       ListTile(
                leading: Icon(
                  Icons.forward
                ) ,
                title: Text('Deconnexion',style: TextStyle(fontSize: 20),),
                onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp() ));
               // AuthService().logout();
                },
              ),  
       ], 
      ),
    );
  }
}
