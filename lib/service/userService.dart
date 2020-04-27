import 'package:trensfert_argent_mobile/authService.dart';
import 'package:trensfert_argent_mobile/helper/interceptor.dart';

import '../modele/user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class UserService{


   final baseUrl ='http://10.0.2.2:8000/api';
   Future<List< User>> getUsers() async{
     String url='$baseUrl/users';
     final response = await http.get(url);
     print(response.body);
      if (response.statusCode == 200) {
    return json.decode(response.body);
      } else {
    throw Exception('Failed to load album');
      }
     
   }
}