// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'AuthModel.dart';

class NotificationModel extends ChangeNotifier {
  NotificationModel({
    this.image,
    this.price,
    this.notificationId,
    this.productId,
    this.productName,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      image: json["destination"],
      price: json["price"],
      notificationId: json["notification_id"],
      productId: json["id"],
      productName: json["product_name"],
    );
  }

  final int notificationId;
  final int productId;
  final String productName;
  final String price;
  final String image;

  Future<List<NotificationModel>> getAllNotificationModels() async {
    final token = await Auth().getToken();
    final List<NotificationModel> products = [];
    final response = await http.get(
        Uri.http(
          serverURL,
          "/api/user/get-notifications",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        products.add(NotificationModel.fromJson(product));
      }
      return products;
    } else {
      return null;
    }
  }

  Future addNotification(int id) async {
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.http(
          serverURL,
          "/api/user/add-to-notifications/$id",
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

  Future removeNotification(int id) async {
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.http(
          serverURL,
          "/api/user/remove-from-notifications/$id",
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
