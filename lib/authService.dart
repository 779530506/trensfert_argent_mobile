import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trensfert_argent_mobile/service/environnement.dart';

class AuthService  {
  final baseUrl =Environnement().BASE_URL;
  SharedPreferences sharedPreferences;
Future<String> get tokenOrEmpty async{
      sharedPreferences = await SharedPreferences.getInstance();
      var token = await sharedPreferences.get('token') ?? 0;
       //print(jsonDecode(token)['token']);
       if(token == null) return "";
       return token;
}
    getToken() async {
    var tok = await tokenOrEmpty;
    String jwt = jsonDecode(tok)['token'];
     return jwt ;
}
Future<String> attemptLogIn(String username, String password) async {
  var res = await http.post(
    "$baseUrl/login_check",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body:jsonEncode(<String,String> {
      "username": username,
      "password": password
    })
  );
  if(res.statusCode == 200) return res.body;
  return null;
}

}
