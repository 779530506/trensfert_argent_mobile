import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/menu.dart';
import 'package:http/http.dart' as http;
import 'package:trensfert_argent_mobile/service/environnement.dart';
import 'package:trensfert_argent_mobile/widget/compteView.dart';
import 'dart:convert';

import 'package:trensfert_argent_mobile/widget/userView.dart';


class CompteList extends StatefulWidget {
  @override
  _CompteListState createState() => _CompteListState();
}

class _CompteListState extends State<CompteList> {
  var sharedPreferences ;
    var comptes=[];
    int currentPage=1;
    int size=7;
    int totalPage;
    int comptesLength;
     ScrollController _scrollController = new ScrollController();
     final baseUrl =Environnement().BASE_URL;
   getComptes() async{
     String url='$baseUrl/comptes?page=$currentPage';
        var token = await  AuthService.getToken();
        print(token);
        http.get(
               url,
               headers: {HttpHeaders.authorizationHeader: "bearer $token"},
          ).then(
            (data){
             setState(() {
             var comptes = json.decode(data.body);
             comptesLength = comptes['hydra:totalItems'];
             comptes = comptes['hydra:member'];
             for(var compte in comptes){
                 this.comptes.add(compte);
             }
              if(comptesLength % size == 0)
              totalPage = comptesLength ~/ size;
              else
              totalPage = (comptesLength/size).floor();
            });
         }
          ).catchError((error){
            print(error);
          });     
   }

  @override
  void initState() {
    super.initState();
    getComptes();
     _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        if(currentPage<totalPage){
        ++currentPage;
        this.getComptes();
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
      appBar:AppBar(title: Text("Les comptes"),backgroundColor: Colors.deepOrange,),
      body: (this.comptes.length == 0 ?
      Center(child: CircularProgressIndicator(),)
      :ListView.builder(
        controller: _scrollController,
        itemCount: (comptes==null ? 0 : comptes.length),
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
                          color: Colors.deepOrange
                          ),
                        onPressed: (){
                           var id = this.comptes[index]['id'];
                          // var date = this.comptes[index]['createdDate'];
                           print(id);
                           Navigator.push(
                            context,
                                MaterialPageRoute(
                                    builder: (context) =>CompteView(id: id,),
                              )
                            );
                        },
                    ),
                  ),
                    Text("${this.comptes[index]['numeroCompte']}", style: TextStyle(fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30,0,0,0),
                      child: Text("${this.comptes[index]['solde']}   Fcfa",
                       style: TextStyle(fontSize: 20,color: Colors.deepOrangeAccent, fontStyle: FontStyle.italic,
                       fontWeight: FontWeight.bold),),
                    ),
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