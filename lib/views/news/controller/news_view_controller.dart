// // ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types, avoid_void_async, invariant_booleans, unused_local_variable, avoid_dynamic_calls

// import 'package:get/state_manager.dart';
// import 'package:medicine_app/constants/constants.dart';
// import 'package:medicine_app/models/ProductsModel.dart';

// class NewInComeController extends GetxController {
//   int addCart = 0;
//   RxList list = [].obs;
//   RxInt loading = 0.obs;
//   final page = 1.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   void fetchProducts() async {
//     final products = await Product().getProducts(parametrs: {"page": '$page', "limit": '20', "new_in_come": "1"});
//     if (products != null) {
//       loading.value = 1;
//       for (final element in products) {
//         addCart = 0;
//         for (final element2 in myList) {
//           if (element.id == element2["id"]) {
//             addCart = element2["cartQuantity"];
//           }
//         }
//         list.add({"id": element.id, "name": element.productName, "price": element.price, "image": element.images, "stockCount": element.stockCount, "cartQuantity": addCart});
//       }
//     } else if (products.isEmpty) {
//       loading.value = 2;
//     } else {
//       loading.value = 3;
//     }
//   }

//   addPage() {
//     int a = 0;
//     a = pageNumber;
//     if ((a / 20) > page.value + 1) {
//       page.value += 1;
//       fetchProducts();
//     }
//   }

//   refreshPage() {
//     page.value = 1;
//     list.clear();
//     loading.value = 0;
//     fetchProducts();
//   }

//   void removeCard(int id) {
//     for (final element in list) {
//       if (element["id"] == id) {
//         element["cartQuantity"] -= 1;
//       }
//     }
//     list.refresh();
//   }

//   void addedToCard(int id) {
//     for (final element in list) {
//       if (element["id"] == id) {
//         element["cartQuantity"] += 1;
//       }
//     }
//     list.refresh();
//   }

//   void upgradeValue(int id, int quantity) {
//     for (final element in list) {
//       if (element["id"] == id) {
//         element["quantity"] = quantity;
//       }
//     }
//     list.refresh();
//   }
// }
