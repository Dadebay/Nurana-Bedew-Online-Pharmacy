import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:medicine_app/constants/constants.dart';

import 'auth_service.dart';

class SignINService {
  Future loginUser({required String phone, required String password}) async {
    final response = await http.post(Uri.parse('$serverURL/api/user/login'),
        headers: <String, String>{HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          "phone": phone,
          "password": password,
        }));
    if (response.statusCode == 200) {
      Auth().setToken(jsonDecode(response.body)["access_token"]);
      // Auth().login(jsonDecode(response.body)["data"]);
      return true;
    } else {
      return false;
    }
  }
}
