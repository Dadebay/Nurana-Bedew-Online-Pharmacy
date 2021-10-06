// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/Auth/Login.dart';
import '../constants/constants.dart';
import 'AuthModel.dart';

class Product extends ChangeNotifier {
  Product({
    this.id,
    this.stockCount,
    this.price,
    this.productName,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json["id"],
        productName: json["product_name"],
        stockCount: json["stock_count"],
        price: json["price"],
        images: json["image"]);
  }

  final int id;
  final String images;
  final int price;
  final String productName;
  final int stockCount;

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
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["products"];
      for (final Map product in responseJson) {
        products.add(Product.fromJson(product));
      }
      return products;
    } else if (response.statusCode == 402) {
      Auth().refreshToken().then((value) {
        if(value==true){
   final responseJson = jsonDecode(response.body)["rows"][0]["products"];
      for (final Map product in responseJson) {
        products.add(Product.fromJson(product));
      }
      return products;
        }else{
          
        }
      });
    
    } else if (response.statusCode == 403) {
      print("casca");
      //login sahypa gidirmeli
      // Future.delayed(const Duration(milliseconds: 200), () {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
      // });
    } else {
      return null;
    }
  }
}
