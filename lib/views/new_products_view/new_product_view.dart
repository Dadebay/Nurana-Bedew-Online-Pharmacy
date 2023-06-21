import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/views/home_view/views/search_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/app_bar_static.dart';
import '../../constants/cards/products_card.dart';
import '../../constants/constants.dart';
import '../home_view/controllers/home_view_controller.dart';

class NewInCome extends StatelessWidget {
  final HomeViewController homePageController = Get.put(HomeViewController());

  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    homePageController.newProductsList.clear();
    homePageController.loadingNewProducts.value = 0;

    homePageController.getDataNewProducts();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    homePageController.pageNewProducts.value++;

    homePageController.getDataNewProducts();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          name: "newInCome",
          backArrow: false,
          icon: IconlyLight.search,
          onTap: () {
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
              if (homePageController.loadingNewProducts.value == 1) {
                return Center(child: Text('emptyStockMin'.tr));
              } else if (homePageController.loadingNewProducts.value == 2) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: homePageController.newProductsList.length,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        orderedProductView: false,
                        model: homePageController.newProductsList[index],
                      );
                    });
              } else {
                return spinKit();
              }
            })));
  }
}
