// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types, avoid_void_async, invariant_booleans, unused_local_variable, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine_app/constants/widgets.dart';

import '../../../data/models/products_model.dart';
import '../../../data/services/products_service.dart';

class HomeViewController extends GetxController {
  RxBool agreeButton = false.obs;
  RxInt loading = 0.obs;
  RxInt loadingNewProducts = 0.obs;
  RxInt newProductsCount = 0.obs;
  RxInt page = 1.obs;
  RxInt productsCount = 0.obs;
  RxInt pageNewProducts = 1.obs;
  List<ProductModel> productsList = <ProductModel>[].obs;
  List<ProductModel> newProductsList = <ProductModel>[].obs;
  late Future<List<ProductModel>> newProducts;
  late Future<List<ProductModel>> products;
  var ru = const Locale(
    'ru',
  );

  final storage = GetStorage();
  var tm = const Locale(
    'tr',
  );

  @override
  void onInit() {
    getData();
    getDataNewProducts();
  }

  dynamic getData() {
    products = ProductsService().getProducts(parametrs: {'page': "${page}", 'limit': "20"}).then((value) {
      if (value.isEmpty) {
        loading.value = 1;
      } else {
        loading.value = 2;
        productsList += value;
      }
      return value;
    });
  }

  dynamic getDataNewProducts() {
    if (newProductsCount.value == newProductsList.length && newProductsList.isNotEmpty) {
      showSnackBar('endTitle', 'endSubtitle', Colors.red);
    } else {
      newProducts = ProductsService().getProducts(parametrs: {'page': "${pageNewProducts}", 'limit': "20", 'new_in_come': '1'}).then((value) {
        if (value.isEmpty) {
          loadingNewProducts.value = 1;
        } else {
          loadingNewProducts.value = 2;
          newProductsList += value;
        }
        return value;
      });
    }
  }

  dynamic switchLang(String value) {
    if (value == 'ru') {
      Get.updateLocale(ru);
      storage.write('langCode', 'ru');
    } else {
      Get.updateLocale(tm);
      storage.write('langCode', 'tr');
    }
    update();
  }
}
