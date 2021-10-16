// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:medicine_app/Others/Models/AuthModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';

class OrdersModel extends ChangeNotifier {
  final int id;

  final String createdAt;
  final String totalPrice;

  OrdersModel({this.id, this.createdAt, this.totalPrice});

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
        id: json["id"],
        createdAt: json["created_at"],
        totalPrice: json["total_price"]);
  }

  Future<List<OrdersModel>> getorders() async {
    final token = await Auth().getToken();
    final List<OrdersModel> orders = [];
    final response = await http.get(
        Uri.http(
          serverURL,
          "/api/user/get-orders",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["orders"];
      for (final Map product in responseJson) {
        orders.add(OrdersModel.fromJson(product));
      }
      return orders;
    } else {
      return null;
    }
  }
}
