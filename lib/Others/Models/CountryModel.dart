// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/Others/constants/constants.dart';

import 'AuthModel.dart';

class CountryModel extends ChangeNotifier {
  CountryModel({this.id, this.countryName});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(id: json["id"], countryName: json["country_name"]);
  }

  final String countryName;
  final int id;

  Future<List<CountryModel>> getCountries() async {
    final token = await Auth().getToken();
    final List<CountryModel> countries = [];
    final response = await http.get(
        Uri.http(
          serverURL,
          "/api/user/get-countries",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["countries"];
      for (final Map product in responseJson) {
        countries.add(CountryModel.fromJson(product));
      }
      return countries;
    } else {
      return null;
    }
  }
}
