// ignore_for_file: avoid_positional_boolean_parameters, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/willPopScope.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/controllers/BottomNavBarController.dart';
import 'package:medicine_app/controllers/CartPageController.dart';
import 'package:medicine_app/controllers/HomePageController.dart';
import 'package:medicine_app/controllers/NewInComeController.dart';
import 'package:medicine_app/views/NewIncomesPage/NewInCome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CartPage/CartPage.dart';
import 'HomePage/HomePage.dart';
import 'Profile/Profile.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final BottomNavBarController controller = Get.put(BottomNavBarController());

  List<Widget> page = [HomePage(), NewInCome(), CartPage(), Profile()];
  Future<bool> saveData(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool("firstTime", value);
  }

  @override
  void initState() {
    saveData(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyWillPopScope(
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                  backgroundColor: Colors.white,
                  iconSize: 30,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: kPrimaryColor,
                  unselectedItemColor: Colors.grey[400],
                  currentIndex: controller.selectedIndex,
                  onTap: (index) {
                    controller.selectedIndex = index;
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(IconlyLight.home),
                      activeIcon: Icon(IconlyBold.home),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(IconlyLight.paper),
                      activeIcon: Icon(IconlyBold.paper),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(IconlyLight.bag),
                      activeIcon: Icon(IconlyBold.bag),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(IconlyLight.profile),
                      activeIcon: Icon(IconlyBold.profile),
                      label: "",
                    ),
                  ],
                )),
            body: Obx(() {
              return page[controller.selectedIndex];
            })),
      ),
    );
  }
}
