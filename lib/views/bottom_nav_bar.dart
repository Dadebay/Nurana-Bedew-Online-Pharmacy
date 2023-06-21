import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/views/user_profile/user_profile_view.dart';

import 'cart_view/views/cart_view.dart';
import 'home_view/views/home_view.dart';
import 'new_products_view/new_product_view.dart';
import 'news/view/news_view.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List pages = [
    HomeView(),
    NewInCome(),
    News(),
    CartView(),
    UserProfil(),
  ];

  int selecedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 11, fontFamily: montserratSemiBold),
          unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 10, fontFamily: montserratSemiBold),
          showUnselectedLabels: true,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: selecedIndex,
          onTap: (index) async {
            selecedIndex = index;
            // Get.find<CartViewController>().cartList.clear();
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.home, size: 24),
              activeIcon: Icon(IconlyBold.home, size: 27),
              label: "homePage".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.document, size: 24),
              activeIcon: Icon(IconlyBold.document, size: 27),
              label: "new".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.paper, size: 24),
              activeIcon: Icon(IconlyBold.paper, size: 27),
              label: 'NewsPageName'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.bag, size: 24),
              activeIcon: Icon(IconlyBold.bag, size: 27),
              label: 'cart'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile, size: 24),
              activeIcon: Icon(IconlyBold.profile, size: 27),
              label: 'profil'.tr,
            ),
          ],
        ),
        body: pages[selecedIndex]);
  }
}
