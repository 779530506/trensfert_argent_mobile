import 'package:flutter/material.dart';
class AlertMessage{
  static alert(context, String title,String content) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
        title: Text(title,style: TextStyle(fontSize: 34),),
        content: Text(content,style:TextStyle(fontSize: 20),),
        actions: <Widget>[
          FlatButton(
            shape: new RoundedRectangleBorder(
                 borderRadius: new BorderRadius.circular(15.0)),
            child: Text('Submit',style:TextStyle(fontSize: 20),),
            color: Colors.deepOrange,
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Accueil()));
            },
          ),
        ],
        ) 
      );
  }
}