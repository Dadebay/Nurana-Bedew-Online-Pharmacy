import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthModel.dart';

class CartModel extends ChangeNotifier {
  CartModel({
    this.id,
    this.stockCount,
    this.quantity,
    this.price,
    this.productName,
    this.images,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(id: json["id"], productName: json["product_name"], stockCount: json["stock_count"], price: json["price"], quantity: json["quantity"], images: json["image"]);
  }

  final int id;
  final String images;
  final String price;
  final String productName;
  final int quantity;
  final int stockCount;

  Future<List<CartModel>> getCartProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMap = prefs.getString('cart');
    final List decodedMap = jsonDecode(encodedMap);
    final body = json.encode(decodedMap);

    final token = await Auth().getToken();
    final List<CartModel> products = [];

    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/get-cart-products",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{"qty": body}));

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["products"];
      for (final Map product in responseJson) {
        products.add(CartModel.fromJson(product));
      }

      return products;
    } else {
      return null;
    }
  }

  Future addToCart({Map<String, String> parametrs, int id}) async {
    final token = await Auth().getToken();

    final response = await http.post(Uri.parse("$serverURL/api/user/add-to-cart/$id").replace(queryParameters: parametrs), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future order(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMap = prefs.getString('cart');
    final List decodedMap = jsonDecode(encodedMap);
    final body = json.encode(decodedMap);
    print(id);
    print(decodedMap);
    final token = await Auth().getToken();
    print(token);

    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/create-order/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{"qty": body}));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updateCartProduct({
    int cartID,
    int productId,
    Map<String, String> parametrs,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$serverURL/api/user/update-cart-product/$cartID/$productId").replace(queryParameters: parametrs), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteCartProduct({
    int cartID,
    int productId,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/remove-cart-item/$cartID/$productId",
        ),
        headers: <String, String>{
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
