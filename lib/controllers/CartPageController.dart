// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types

import 'dart:convert';
import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/models/AuthModel.dart';
import 'package:medicine_app/models/CartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPageController extends GetxController {
  RxList list = [].obs;
  RxInt loading = 0.obs;
  RxInt productQuntity = 0.obs;
  @override
  void onInit() {
    loading.value = 0;
    loadData();
    super.onInit();
  }

  Future<List<CartModel>> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMap = prefs.getString('cart');
    final List decodedMap = json.decode(encodedMap);
    final body = json.encode(decodedMap);

    final token = await Auth().getToken();

    final response =
        await http.post(Uri.http(serverURL, "/api/user/get-cart-products"),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{"qty": body}));
    if (response.statusCode == 200 &&
        (jsonDecode(response.body)["rows"]) != null) {
      loading.value = 1;
      list.clear();
      final responseJson = jsonDecode(response.body)["rows"]["products"];
      for (final Map product in responseJson) {
        list.add({
          "id": CartModel.fromJson(product).id,
          "name": CartModel.fromJson(product).productName,
          "quantity": 0,
          "image": CartModel.fromJson(product).images,
          "price": CartModel.fromJson(product).price,
          "stockMin": CartModel.fromJson(product).stockCount
        });
      }
      for (int i = 0; i < list.length; i++) {
        for (int j = 0; j < myList.length; j++) {
          if (list[i]["id"] == myList[j]["id"]) {
            list[i]["quantity"] = myList[j]["cartQuantity"];
          }
        }
      }
      return null;
    } else {
      loading.value = 2;
      return null;
    }
  }
}
