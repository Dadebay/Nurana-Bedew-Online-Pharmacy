import '../models/news_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import 'auth_service.dart';

class NewsService {
  Future<List<NewsModel>> getNews() async {
    final token = await Auth().getToken();
    final List<NewsModel> newsList = [];

    final response = await http.get(Uri.parse("$serverURL/api/user/get-news"), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["news"];
      if (responseJson == null) {
        return [];
      } else {
        for (final Map product2 in responseJson) {
          newsList.add(NewsModel.fromJson(product2));
        }
        return newsList;
      }
    } else {
      return [];
    }
  }
}
