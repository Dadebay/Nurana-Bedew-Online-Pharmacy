// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/Others/constants/constants.dart';

import 'AuthModel.dart';

class ProducerModel extends ChangeNotifier {
  ProducerModel({this.id, this.producerName});

  factory ProducerModel.fromJson(Map<String, dynamic> json) {
    return ProducerModel(id: json["id"], producerName: json["producer_name"]);
  }

  final String producerName;
  final int id;

  Future<List<ProducerModel>> getProducer() async {
    final token = await Auth().getToken();
    final List<ProducerModel> countries = [];
    final response = await http.get(
        Uri.http(
          serverURL,
          "/api/user/get-producers",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["producers"];
      for (final Map product in responseJson) {
        countries.add(ProducerModel.fromJson(product));
      }
      return countries;
    } else {
      return null;
    }
  }
}
