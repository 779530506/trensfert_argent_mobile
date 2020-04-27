import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './modele/user.dart';

class AuthService  {
  final baseUrl ='http://10.0.2.2:8000/api';
  SharedPreferences sharedPreferences;
  // String token ;
  // Map<String, String> get header => {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE1ODc4Mjg2OTMsImV4cCI6MTU4NzgzMjI5Mywicm9sZXMiOlsiUk9MRV9BRE1JTiJdLCJ1c2VybmFtZSI6ImFkbWluIn0.APo-Qx2BSj9bBGgeTHWgdfom5IcqMxLnHEv5Q1w2ObEM-1CLZei6d5W-UD7Rk0A0qPdzTtjCHRpGM7LW37p8ktqWbp0G08qlNKBrjsuZVWE9sxwrzZizVGF_TUvVVsqdaZc8HCVoe1598tcOMUuyqdWFxTUmYtDFyjkKB6A8nkBX4t-1fQVwr6X5WJdAa76fmOmf3RCaivMNdDKc-XK2nZQICE8D5McJa59p-h6pamBgPYIjrWFUfCfNtGT86a-TS4se3oZsBuMgQlxiyOqC0uN2XiZwoGnsikIoTdP2BhXPeZ8CM4tUf2B7jhfwQ9QA70ch37Rpmbdof7DTOpx3QVovOMXV81gxzRkDr96gdvAdcKqIoObhFJ_qAqFBZh_awsaz3Rg9vvRpFAcW00cRX3Y_7Szb8uqhSVr_3Bl8EFQlRNApqk7NXsnpzUDcQqbkKDZMCcfMRZSJfISBd2vKU3v-kb_NPNqz33opnXA8rLOmTUEeOFfAh2GchT9zIcXRHVll5K6lnYXemR1nZp1qThqFzPIW52K36uWTIUIySGtoke3ALpYRBfCXs_2Zi9btWAXgQg-Ea3I1vw2vZw1nZ7nD3fPZWO7LOqTIjJBWym85U9ltLB5tjMcowMggzyKiMjv-dXrC6Hb8Epq6r3cX5HDTCwgbQx8OFrMIXnfVBxo ",
  //     };

  logout(){
   sharedPreferences.clear();
  }
  setToken(String token) async {
     sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences.setString('token', token);
    }
  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
     final value = await sharedPreferences.get('token') ?? 0;
     print('token: $value');
     return value;

}
 Future<User> login(String username, String password) async {
     String url ='$baseUrl/login_check';
     final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String,String> {
      'username': username,
      'password': password
     }),
  );
   var status =response.statusCode;
   print(status);
   print(username);
   var resp= json.decode(response.body);
   print(resp);
   if(status == 200){
    setToken(resp['token']);
    getToken();
     return User.fromJson(json.decode(response.body));
   } else{
    print('code : ${resp['code']} ,message : ${resp['message']}');
    throw Exception(resp['message']);
   }

}


}
