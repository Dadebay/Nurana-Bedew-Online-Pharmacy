// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:medicine_app/Others/constants/NavService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  Future loginUser({String phone, String password}) async {
    final response =
        await http.post(Uri.http('192.168.31.138:8000', "/api/user/login"),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "phone": phone,
              "password": password,
            }));

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["data"];
      Auth().setToken(jsonDecode(response.body)["access_token"]);
      Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"]);
      Auth().login(
          name: responseJson["name"],
          uid: responseJson["id"],
          phone: responseJson["user"],
          gmail: responseJson["email"]);
      return true;
    } else {
      return false;
    }
  }

  Future refreshToken() async {
    final refreshToken = await Auth().getRefreshToken();
    final response =
        await http.post(Uri.http('192.168.31.138:8000', "/api/user/refresh"),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "refresh_token": refreshToken,
            }));
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["data"];
      Auth().setToken(jsonDecode(response.body)["access_token"]);
      Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"]);
      Auth().login(
          name: responseJson["name"],
          uid: responseJson["id"],
          phone: responseJson["user"],
          gmail: responseJson["email"]);
      return true;
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        NavigationService.instance.navigateToReplacement("login");
      });
    }
  }

  SharedPreferences _prefs;

  Future<bool> login({String name, int uid, String phone, String gmail}) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('name', name);
    await _prefs.setInt('uid', uid);
    await _prefs.setString('phone', phone);
    await _prefs.setString('gmail', gmail);
    return _prefs.setBool("isLoggedIn", true);
  }

  Future<bool> logout() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("name");
    await _prefs.remove("uid");
    await _prefs.remove("gmail");
    await _prefs.remove("phone");
    return _prefs.setBool("isLoggedIn", false);
  }

  /////////////////////////////////////////User Token///////////////////////////////////

  Future<bool> setToken(String token) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }

  Future<bool> removeToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.remove('token');
  }

  /////////////////////////////////////////User Token///////////////////////////////////
/////////////////////////////////////////User Refresh Token///////////////////////////////////

  Future<bool> setRefreshToken(String token) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('refreshtoken', token);
  }

  Future<String> getRefreshToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('refreshtoken');
  }

  Future<bool> removeRefreshToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.remove('refreshtoken');
  }
}
