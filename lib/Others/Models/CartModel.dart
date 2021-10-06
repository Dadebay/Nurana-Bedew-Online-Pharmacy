// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/Others/constants/constants.dart';

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
    return CartModel(
        id: json["id"],
        productName: json["product_name"],
        stockCount: json["stock_count"],
        price: json["price"],
        quantity: json["quantity"],
        images: json["image"]);
  }

  final int id;
  final String images;
  final int price;
  final String productName;
  final int quantity;
  final int stockCount;

  Future<List<CartModel>> getCartProducts() async {
    final token = await Auth().getToken();
    final List<CartModel> products = [];
    final response = await http.get(
        Uri.http(
          serverURL,
          "/api/user/get-cart-products",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson =
          jsonDecode(response.body)["rows"][0]["cart_products"];
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

    final response = await http.post(
        Uri.http(serverURL, "/api/user/add-to-cart/$id", parametrs),
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

  Future order() async {
    final token = await Auth().getToken();

    final response = await http.post(
        Uri.http(serverURL, "/api/user/create-order"),
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

  Future updateCartProduct({
    int cartID,
    int productId,
    Map<String, String> parametrs,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.http(serverURL, "/api/user/update-cart-product/$cartID/$productId",
            parametrs),
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

  Future deleteCartProduct({
    int cartID,
    int productId,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.http(
          serverURL,
          "/api/user/remove-cart-item/$cartID/$productId",
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
