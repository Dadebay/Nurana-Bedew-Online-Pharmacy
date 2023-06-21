import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/buttons/retry_button.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/shimmers/products_shimmer.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/views/home_view/controllers/search_view_contoller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/cards/products_card.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

List<Map<String, dynamic>> priceName = [
  {"name": 'expensive'.tr, "number": 0},
  {"name": 'cheapest'.tr, "number": 1}
];

class _SearchViewState extends State<SearchView> {
  final SearchController searchController = Get.put(SearchController());
  late Timer searchOnStoppedTyping;
  _onChangeHandler(value) {
    const duration = Duration(seconds: 1);
    setState(() => searchOnStoppedTyping.cancel());
    setState(() => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) {
    searchController.list.clear();
    searchController.loading.value = 0;
    searchController.fetchProducts(
      productName: textEditingController.text,
    );
  }

  TextEditingController textEditingController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchOnStoppedTyping = Timer(Duration(seconds: 1), () {});
    searchController.priceValue.value = "";
    searchController.newInCome.value = "";
    searchController.page.value = 1;
    searchController.loading.value = 0;
    searchController.list.clear();
    searchController.fetchProducts(productName: "");
  }

  void _onRefresh() {
    textEditingController.clear();
    searchController.priceValue.value = "";
    searchController.newInCome.value = "";
    searchController.page.value = 1;
    searchController.list.clear();
    searchController.fetchProducts(productName: "");
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    // searchController.addPage();
    searchController.page.value += 1;
    searchController.fetchProducts(productName: "");

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        appBar: appBar(),
        endDrawer: endDrawer(),
        body: SmartRefresher(
            enablePullUp: true,
            physics: const BouncingScrollPhysics(),
            header: const MaterialClassicHeader(color: kPrimaryColor),
            footer: footer(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Obx(() {
              if (searchController.loading.value == 1) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.list.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        model: searchController.list[index],
                        orderedProductView: false,
                      );
                    });
              } else if (searchController.loading.value == 2) {
                return Center(
                  child: Text("emptyStockMin".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold)),
                );
              } else if (searchController.loading.value == 3) {
                return RetryButton(onTap: () {});
              } else if (searchController.loading.value == 0) {
                return ProductShimmer().shimmer(20);
              }
              return const Text("Loading...", style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold));
            })));
  }

  AppBar appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(IconlyLight.arrowLeft2, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(IconlyLight.filter, color: Colors.white),
            ),
          )
        ],
        centerTitle: true,
        bottom: PreferredSize(preferredSize: Size.fromHeight(75), child: Container(color: Colors.white, child: searchTextField())),
        title: Text(
          "search".tr,
          style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold),
        ));
  }

  int a = 0;
  bool mine = false;
  Padding searchTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: textEditingController,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 17),
        cursorColor: kPrimaryColor,
        onEditingComplete: () {
          searchController.list.clear();
          searchController.loading.value = 0;
          // searchController.fetchProducts(productName: textEditingController.text);
        },
        onSubmitted: (value) {
          search(value);
        },
        onChanged: _onChangeHandler,
        decoration: InputDecoration(
          hintText: "search".tr,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          suffixIcon: IconButton(
            icon: Icon(IconlyLight.search, size: 26, color: Colors.black),
            color: kPrimaryColor,
            onPressed: () {},
          ),
          hintStyle: const TextStyle(color: Colors.black38, fontFamily: montserratMedium),
          filled: true,
          fillColor: Colors.grey[200],
          focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
          enabledBorder: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
        ),
      ),
    );
  }

  bool newInComeValue = false;
  int priceValue = -1;
  Drawer endDrawer() {
    return Drawer(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Text(
                    "search".tr,
                    style: TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black),
                  ),
                ),
                dividerr(),
                ExpansionTile(
                  title: Text("priceName".tr,
                      style: const TextStyle(
                        fontFamily: montserratMedium,
                      )),
                  collapsedIconColor: Colors.grey,
                  iconColor: kPrimaryColor,
                  textColor: kPrimaryColor,
                  collapsedTextColor: Colors.grey,
                  children: [
                    RadioListTile(
                      value: 1,
                      activeColor: kPrimaryColor,
                      groupValue: priceValue,
                      onChanged: (int? ind) {
                        setState(() {
                          priceValue = ind ?? 1;
                          searchController.priceValue.value = "$priceValue";
                        });
                      },
                      title: Text(
                        priceName[0]["name"],
                        style: const TextStyle(fontFamily: montserratRegular),
                      ),
                    ),
                    RadioListTile(
                      value: 2,
                      activeColor: kPrimaryColor,
                      groupValue: priceValue,
                      onChanged: (int? ind) {
                        setState(() {
                          priceValue = ind ?? 2;
                          searchController.priceValue.value = "$priceValue";
                        });
                      },
                      title: Text(
                        priceName[1]["name"],
                        style: const TextStyle(fontFamily: montserratRegular),
                      ),
                    ),
                  ],
                ),
                dividerr(),
                CheckboxListTile(
                  value: newInComeValue,
                  checkColor: Colors.white,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? val) {
                    setState(() {
                      newInComeValue = val ?? true;
                      if (newInComeValue == true) {
                        searchController.newInCome.value = "1";
                      } else {
                        searchController.newInCome.value = "0";
                      }
                    });
                  },
                  title: Text(
                    "newInCome".tr,
                    style: const TextStyle(color: Colors.black, fontFamily: montserratRegular),
                  ),
                ),
                dividerr(),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: SizedBox(
              width: Get.size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: kPrimaryColor,
                    elevation: 1,
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                  ),
                  onPressed: () {
                    searchController.loading.value = 0;
                    searchController.list.clear();
                    searchController.fetchProducts(productName: textEditingController.text);
                    Get.back();
                  },
                  child: Text(
                    "search".tr,
                    style: TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
