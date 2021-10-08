// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'AuthModel.dart';

class ProductModel extends ChangeNotifier {
  ProductModel(
      {this.id,
      this.cartQuantity,
      this.stockCount,
      this.price,
      this.descriptionRu,
      this.descriptionTm,
      this.dateOfExpire,
      this.productName,
      this.categoryName,
      this.countryName,
      this.images,
      this.cartId,
      this.quantity});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      productName: json["product_name"],
      price: json["price"],
      stockCount: json["stock_count"],
      cartQuantity: json["cart_quantity"],
      quantity: json['quantity'],
      categoryName: json["category_name"],
      countryName: json["country_name"],
      descriptionTm: json["description_tm"],
      descriptionRu: json["description_ru"],
      cartId: json["cart_id"],
      dateOfExpire: json["date_of_expire"],
      images: json["image"],
    );
  }

  final String categoryName;
  final String countryName;
  final String dateOfExpire;
  final String descriptionRu;
  final String descriptionTm;
  final String id;
  final String images;
  final String price;
  final String productName;
  final int cartQuantity;
  final int cartId;
  final int stockCount;
  final int quantity;

  Future<ProductModel> getProductById(int id) async {
    final token = await Auth().getToken();
    final response = await http.get(
        Uri.http(serverURL, "/api/user/get-product/$id"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    print(response.body);
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return null;
    }
  }
}
