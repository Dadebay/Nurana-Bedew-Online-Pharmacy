import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../models/notification_model.dart';
import 'auth_service.dart';

class NotificationService {
  Future<List<NotificationModel>> getAllProducts() async {
    final token = await Auth().getToken();
    final List<NotificationModel> products = [];
    final response = await http.get(Uri.parse("$serverURL/api/user/get-notifications"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          products.add(NotificationModel.fromJson(product));
        }
      }
      return products;
    } else {
      return [];
    }
  }

  Future addNotification(int id) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$serverURL/api/user/add-to-notifications/$id"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future removeNotification(int id) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$serverURL/api/user/remove-from-notifications/$id"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
