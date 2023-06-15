import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/views/auth/Login.dart';
import '../constants/constants.dart';
import 'AuthModel.dart';

class ProductModel extends ChangeNotifier {
  ProductModel({this.id, this.stockCount, this.price, this.descriptionRu, this.descriptionTm, this.dateOfExpire, this.productName, this.images, this.producerName, this.quantity});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      productName: json["product_name"],
      price: json["price"],
      stockCount: json["stock_count"],
      quantity: json['quantity'],
      producerName: json["producer_name"],
      descriptionTm: json["description_tm"],
      descriptionRu: json["description_ru"],
      dateOfExpire: json["date_of_expire"],
      images: json["image"],
    );
  }

  final String id;
  final String productName;
  final String price;
  final int stockCount;
  final int quantity;
  final String descriptionRu;
  final String descriptionTm;
  final String dateOfExpire;
  final String images;
  final String producerName;

  Future<ProductModel> getProductById(int id) async {
    final token = await Auth().getToken();
    final response = await http.get(Uri.parse("$serverURL/api/user/get-product/$id"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body)["rows"]);
    } else if (response.statusCode == 402) {
      Auth().refreshToken().then((value) async {
        final token = await Auth().getToken();
        final response = await http.get(Uri.parse("$serverURL/api/user/get-product/$id"), headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
      });

      return Future.delayed(const Duration(milliseconds: 1000), () {
        return ProductModel.fromJson(jsonDecode(response.body)["rows"]);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.toEnd(() => Login());
      });
    }
  }
}
