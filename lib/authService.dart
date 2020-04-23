import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trensfert_argent_mobile/user.dart';

class AuthService  {
 Future<User> login(String username, String password) async {
      String url ='http://10.0.2.2:8000/api/login_check';
     final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password
    }),
  );
   //  print(json.decode(response.body));
   var status =response.body.contains('401');
  // print(status);
   var data= json.decode(response.body);
     _saved(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('token', token);
}
     _read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     final value = await prefs.get('token') ?? 0;
     print('token: $value');

}
   if(status){
    print('code : ${data['code']} ,message : ${data['message']}');
    throw Exception(data['message']);
   }else{
    _saved(data['token']);
    _read();
     return User.fromJson(json.decode(response.body));
  //  var user = User.fromJson(json.decode(response.body));
  //    print(user.token);
   }

}


}
