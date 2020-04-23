import 'package:flutter/material.dart';
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
                title: Text('User',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),  
       ListTile(
                title: Text('Creer un Compte',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),    
       ListTile(
                title: Text('Ajouter un Compte',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ), 
       ListTile(
                title: Text('liste Comptes',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),
       ListTile(
                title: Text('Faire un dépot',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ), 
       ListTile(
                title: Text('Trensfert',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),  
       ListTile(
                title: Text('Retrait',style: TextStyle(fontSize: 20),),
                onTap: (){
                  Navigator.of(context).pop();
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Quiz() ));
                },
              ),                     
       ], 
      ),
    );
  }
}