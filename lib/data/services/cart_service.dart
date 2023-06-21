import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:medicine_app/constants/constants.dart';

import 'auth_service.dart';

class CartService {
  Future createOrder(int id, List orderList) async {
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/create-order/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{"qty": json.encode(orderList)}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
