// ignore_for_file: type_annotate_public_apis, prefer_typing_uninitialized_variables, file_names, missing_return

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/Others/constants/NavService.dart';
import '../constants/constants.dart';
import 'AuthModel.dart';

class Category extends ChangeNotifier {
  Category({
    this.id,
    this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      categoryName: json["category_name"],
    );
  }

  final String categoryName;
  final int id;

  Future<List<Category>> getCategory({Map<String, String> parametrs}) async {
    final token = await Auth().getToken();

    final List<Category> category = [];
    final response = await http.get(
        Uri.http(serverURL, "/api/user/get-categories", parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["categories"];
      for (final Map categories in responseJson) {
        category.add(Category.fromJson(categories));
      }
      return category;
    } else if (response.statusCode == 402) {
      Auth().refreshToken().then((value) async {
        final token = await Auth().getToken();
        final response = await http.get(
            Uri.http(serverURL, "/api/user/get-categories", parametrs),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            });
        final responseJson = jsonDecode(response.body)["rows"][0]["categories"];
        for (final Map product in responseJson) {
          category.add(Category.fromJson(product));
        }
      });

      return Future.delayed(const Duration(milliseconds: 1000), () {
        return category;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        NavigationService.instance.navigateToReplacement("login");
      });
    }
  }
}
