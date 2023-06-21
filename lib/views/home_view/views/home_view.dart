// ignore_for_file: always_declare_return_types, type_annotate_public_apis, file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/views/home_view/controllers/home_view_controller.dart';
import 'package:medicine_app/views/home_view/views/search_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/app_bar_static.dart';
import '../../../constants/cards/products_card.dart';

class HomeView extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();
  final HomeViewController homePageController = Get.put(HomeViewController());

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    homePageController.productsList.clear();
    homePageController.loading.value = 0;

    homePageController.getData();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    if (homePageController.productsCount.value == homePageController.productsList.length && homePageController.productsList.isNotEmpty) {
      showSnackBar('endTitle', 'endSubtitle', Colors.red);
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));

      homePageController.page.value++;
      homePageController.getData();
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          name: "homePage",
          backArrow: false,
          icon: IconlyLight.search,
          onTap: () {
            // Get.find<SearchController>().newInCome.value = "0";
            Get.to(() => SearchView());
          },
        ),
        body: SmartRefresher(
            scrollDirection: Axis.vertical,
            enablePullDown: true,
            enablePullUp: true,
            physics: const BouncingScrollPhysics(),
            header: const MaterialClassicHeader(
              color: kPrimaryColor,
            ),
            footer: footer(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Obx(() {
              if (homePageController.loading.value == 1) {
                return Center(child: Text('Empty'));
              } else if (homePageController.loading.value == 2) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: homePageController.productsList.length,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        model: homePageController.productsList[index],
                        orderedProductView: false,
                      );
                    });
              } else {
                return spinKit();
              }
            })));
  }
}
