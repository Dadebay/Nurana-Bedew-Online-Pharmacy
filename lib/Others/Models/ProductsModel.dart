// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/Others/constants/NavService.dart';

import '../constants/constants.dart';
import 'AuthModel.dart';

class Product extends ChangeNotifier {
  Product(
      {this.id,
      this.stockCount,
      this.price,
      this.productName,
      this.images,
      this.cartQuantity,
      this.cartId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json["id"],
        productName: json["product_name"],
        stockCount: json["stock_count"],
        price: json["price"],
        images: json["image"],
        cartQuantity: json['cart_quantity'],
        cartId: json["cart_id"]);
  }

  final int id;
  final int cartId;
  final String images;
  final int price;
  final String productName;
  final int stockCount;
  final int cartQuantity;
  // ignore: missing_return
  Future<List<Product>> getProducts({
    Map<String, dynamic> parametrs,
  }) async {
    final token = await Auth().getToken();
    final List<Product> products = [];
    final response = await http.get(
        Uri.http(serverURL, "/api/user/get-products", parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["products"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          products.add(Product.fromJson(product));
        }
        return products;
      } else {
        return null;
      }
    } else if (response.statusCode == 402) {
      Auth().refreshToken().then((value) async {
        final token = await Auth().getToken();
        final response = await http.get(
            Uri.http(serverURL, "/api/user/get-products", parametrs),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            });
        final responseJson = jsonDecode(response.body)["rows"][0]["products"];
        for (final Map product in responseJson) {
          products.add(Product.fromJson(product));
        }
      });

      return Future.delayed(const Duration(milliseconds: 1000), () {
        return products;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        NavigationService.instance.navigateToReplacement("login");
      });
    }
  }
}
