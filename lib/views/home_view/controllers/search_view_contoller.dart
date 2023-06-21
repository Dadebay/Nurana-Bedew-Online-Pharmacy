// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types, avoid_void_async, invariant_booleans, unused_local_variable, avoid_dynamic_calls

import 'package:get/state_manager.dart';
import 'package:medicine_app/data/models/products_model.dart';
import 'package:medicine_app/data/services/products_service.dart';

class SearchController extends GetxController {
  RxString newInCome = "0".obs;
  RxList<ProductModel> list = <ProductModel>[].obs;
  RxInt loading = 0.obs;
  final page = 1.obs;
  RxString priceValue = "".obs;
  void fetchProducts({required String productName}) async {
    final products = await ProductsService().getProducts(parametrs: {
      "page": '$page',
      "limit": '20',
      "product_name": productName,
      "price": priceValue.value,
      "new_in_come": newInCome.value,
    }).then((value) {
      if (value.isNotEmpty) {
        for (final element in value) {
          list.add(element);
        }
        loading.value = 1;
      } else if (value.isEmpty) {
        loading.value = 2;
      } else {
        loading.value = 3;
      }
    });
  }
}
