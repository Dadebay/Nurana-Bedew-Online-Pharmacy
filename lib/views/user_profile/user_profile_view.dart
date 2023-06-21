// ignore_for_file: file_names, must_be_immutable, avoid_void_async, always_use_package_imports, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/views/user_profile/waiting_products_view.dart';

import '../../constants/app_bar_static.dart';
import '../../constants/buttons/profile_button.dart';
import '../../constants/widgets.dart';
import 'ordered_product_view.dart';

class UserProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          backArrow: false,
          name: "profil",
          onTap: () {},
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            selectLang(),
            dividerr(),
            ProfileButton(
              name: "orders",
              icon: IconlyLight.document,
              onTap: () {
                Get.to(() => OrderedProductsView());
              },
            ),
            dividerr(),
            ProfileButton(
                name: "notificationName",
                icon: IconlyLight.notification,
                onTap: () {
                  Get.to(() => WaitingProductsView());
                }),
            dividerr(),
            shareApp(),
          ],
        ));
  }
}
