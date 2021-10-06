// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'AuthModel.dart';

class ProductModel extends ChangeNotifier {
  ProductModel({
    this.id,
    this.stockCount,
    this.price,
    this.descriptionRu,
    this.descriptionTm,
    this.dateOfExpire,
    this.productName,
    this.categoryName,
    this.countryName,
    this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json["id"],
        productName: json["product_name"],
        countryName: json["country_name"],
        categoryName: json["category_name"],
        stockCount: json["stock_count"],
        price: json["price"],
        dateOfExpire: json["date_of_expire"],
        descriptionRu: json["description_ru"],
        descriptionTm: json["description_tm"],
        images: json["image"]);
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
  final int stockCount;

  Future<ProductModel> getProductById(int id) async {
    final token = await Auth().getToken();
    final response = await http.get(
        Uri.http(serverURL, "/api/user/get-product/$id"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return null;
    }
  }
}
