import 'dart:convert';
import 'dart:io';

import '../../constants/constants.dart';
import '../models/order_model.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<List<OrdersModel>> getorders() async {
    final token = await Auth().getToken();
    final List<OrdersModel> orders = [];
    final response = await http.get(Uri.parse("$serverURL/api/user/get-orders"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["orders"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          orders.add(OrdersModel.fromJson(product));
        }
      }

      return orders;
    } else {
      return [];
    }
  }
}
