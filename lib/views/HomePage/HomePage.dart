// ignore_for_file: always_declare_return_types, type_annotate_public_apis, file_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/ProductCard.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/controllers/HomePageController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController();

  initState() {
    super.initState();
    homeController.fetchProducts();
  }

  void _onRefresh() {
    homeController.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    homeController.addPage();
    _refreshController.loadComplete();
  }

  final HomePageController homeController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: const MyAppBar(name: "Dermanlar", backArrow: false, icon: IconlyLight.search),
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
              if (homeController.loading.value == 0) {
                return Center(
                  child: spinKit(),
                );
              } else if (homeController.loading.value == 1) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: homeController.list.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        id: homeController.list[index]["id"],
                        name: homeController.list[index]["name"],
                        price: homeController.list[index]["price"],
                        imagePath: homeController.list[index]["image"],
                        stockCount: homeController.list[index]["stockCount"],
                        cartQuantity: homeController.list[index]["cartQuantity"],
                        refreshPage: 1,
                      );
                    });
              } else if (homeController.loading.value == 2) {
                return Center(
                  child: spinKit(),
                );
              } else if (homeController.loading.value == 3) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        homeController.fetchProducts();
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
