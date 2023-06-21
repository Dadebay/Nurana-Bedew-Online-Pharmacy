import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class CartViewController extends GetxController {
  RxList cartList = [].obs;
  // Rx loading = 0.obs;
  final storage = GetStorage();
  void addToCard({required int id, required int quantity, required String name, required String price, required String image, required String stockCount}) {
    if (cartList.isEmpty) {
      cartList.add({'id': id, 'quantity': quantity, 'image': image, 'name': name, 'price': price, 'stockCount': stockCount});
    } else {
      bool value = false;
      for (final element in cartList) {
        if (element['id'] == id) {
          element['quantity'] += 1;
          value = true;
        }
      }
      if (!value) {
        cartList.add({'id': id, 'quantity': quantity, 'image': image, 'name': name, 'price': price, 'stockCount': stockCount});
      }
    }
    cartList.refresh();
    final String jsonString = jsonEncode(cartList);
    storage.write('cartList', jsonString);
  }

  dynamic returnCartList() {
    final result = storage.read('cartList') ?? '[]';
    final List jsonData = jsonDecode(result);
    if (jsonData.isEmpty) {
    } else {
      for (final element in jsonData) {
        cartList.add({
          'id': element['id'],
          'quantity': element['quantity'],
          'image': element['image'],
          'price': element['price'],
          'name': element['name'],
          'stockCount': element['stockCount'],
        });
      }
    }
  }

  void updateCartQuantity(int id) {
    for (var element in cartList) {
      if (element['id'] == id) {
        element['quantity'] += 1;
      }
    }
    cartList.refresh();
    final String jsonString = jsonEncode(cartList);
    storage.write('cartList', jsonString);
  }

  void updateCartQuantityDialog(int id, int count) {
    for (var element in cartList) {
      if (element['id'] == id) {
        element['quantity'] = count;
      }
    }
    cartList.refresh();
    final String jsonString = jsonEncode(cartList);
    storage.write('cartList', jsonString);
  }

  void minusCardElement(int id) {
    for (final element in cartList) {
      if (element['id'] == id) {
        element['quantity'] -= 1;
      }
    }

    cartList.removeWhere((element) => element['quantity'] == 0);
    cartList.refresh();
    final String jsonString = jsonEncode(cartList);
    storage.write('cartList', jsonString);
  }

  void deleteItemFromCart(int id) {
    cartList.removeWhere((element) => element['id'] == id);
    cartList.refresh();
    final String jsonString = jsonEncode(cartList);
    storage.write('cartList', jsonString);
  }
}
