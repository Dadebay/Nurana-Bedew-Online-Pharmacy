// ignore_for_file: always_declare_return_types, type_annotate_public_apis, file_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/ProductCard.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/controllers/NewInComeController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewInCome extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();

  void _onRefresh() {
    newInComeController.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    newInComeController.addPage();
    _refreshController.loadComplete();
  }

  final NewInComeController newInComeController = Get.put(NewInComeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: MyAppBar(name: "newInCome".tr, backArrow: false, icon: IconlyLight.search),
        body: SmartRefresher(
            enablePullUp: true,
            physics: const BouncingScrollPhysics(),
            primary: true,
            header: const MaterialClassicHeader(
              color: kPrimaryColor,
            ),
            footer: loadMore("pull_up_to_load"),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Obx(() {
              if (newInComeController.loading.value == 0) {
                return Center(
                  child: spinKit(),
                );
              } else if (newInComeController.loading.value == 1) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: newInComeController.list.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 1100 ? 2 : 4, childAspectRatio: 3 / 4.5),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        id: newInComeController.list[index]["id"],
                        name: newInComeController.list[index]["name"],
                        price: newInComeController.list[index]["price"],
                        imagePath: newInComeController.list[index]["image"],
                        stockCount: newInComeController.list[index]["stockCount"],
                        cartQuantity: newInComeController.list[index]["cartQuantity"],
                        refreshPage: 2,
                      );
                    });
              } else if (newInComeController.loading.value == 2) {
                return Center(
                  child: Text(
                    "noProduct".tr,
                    style: const TextStyle(fontFamily: popPinsSemiBold, fontSize: 20),
                  ),
                );
              } else if (newInComeController.loading.value == 3) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        newInComeController.fetchProducts();
                      },
                      child: const Icon(Icons.refresh, color: kPrimaryColor, size: 35)),
                );
              }
              return Center(
                child: spinKit(),
              );
            })));
  }
}
