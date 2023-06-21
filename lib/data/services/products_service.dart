import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/views/home_view/controllers/home_view_controller.dart';

import '../../constants/constants.dart';
import '../models/products_model.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

class ProductsService {
  Future<ProductByIDModel> getProductById(int id) async {
    final token = await Auth().getToken();
    final response = await http.get(Uri.parse("$serverURL/api/user/get-product/$id"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return ProductByIDModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      showSnackBar('Ýalňyş', 'Ýalňyşlyk ýüze çykdy täzeden synanşyň', Colors.red);

      return ProductByIDModel();
    }
  }

  Future<List<ProductModel>> getProducts({required Map<String, dynamic> parametrs}) async {
    print(parametrs);
    print(parametrs);
    print(parametrs);
    print(parametrs);
    print(parametrs);
    final List<ProductModel> products = [];
    final response = await http.get(Uri.parse("$serverURL/api/user/get-products").replace(queryParameters: parametrs), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["products"];
      if (parametrs['new_in_come'] == '1') {
        Get.find<HomeViewController>().newProductsCount.value = int.parse(jsonDecode(response.body)["rows"][0]["count"].toString());
      } else {
        Get.find<HomeViewController>().productsCount.value = int.parse(jsonDecode(response.body)["rows"][0]["count"].toString());
      }
      if (responseJson == null) {
        return [];
      } else {
        for (final Map product in responseJson) {
          products.add(ProductModel.fromJson(product));
        }
        return products;
      }
    } else {
      showSnackBar('Ýalňyş', 'Ýalňyşlyk ýüze çykdy täzeden synanşyň', Colors.red);
      return [];
    }
  }

  Future<List<OrderedProductProfilModel>> getOrderedProducts({required int id}) async {
    final token = await Auth().getToken();
    final List<OrderedProductProfilModel> orders = [];
    final response = await http.get(Uri.parse("$serverURL/api/user/get-order/$id"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["products"];
      for (final Map product in responseJson) {
        orders.add(OrderedProductProfilModel.fromJson(product));
      }
      return orders;
    } else {
      showSnackBar('Ýalňyş', 'Ýalňyşlyk ýüze çykdy täzeden synanşyň', Colors.red);
      return [];
    }
  }
}
