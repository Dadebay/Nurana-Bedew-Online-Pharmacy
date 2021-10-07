// ignore_for_file: prefer_const_constructors, implementation_imports, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Others/constants/constants.dart';
import '../Others/constants/widgets.dart';
import 'CartPage/Cart.dart';
import 'CategoryPage.dart';
import 'HomePage/HomePage.dart';
import 'Profile/Profile.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController pageController = PageController();
  int selectedIndex;
  List<Widget> _pages;
  // ignore: avoid_positional_boolean_parameters
  Future<bool> saveData(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool("firstTime", value);
  }

  @override
  void initState() {
    saveData(true);
    super.initState();
    selectedIndex = 0;
    _pages = <Widget>[HomePage(), CategoryPage(), CartPage(), Profile()];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return backPressed(size, context);
        },
        // ignore: require_trailing_commas
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            // elevation: 5,
            backgroundColor: Colors.white,
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: Colors.grey[400],
            currentIndex: selectedIndex,
            onTap: (index) {
              pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.home),
                activeIcon: Icon(IconlyBold.home),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.category),
                activeIcon: Icon(IconlyBold.category),
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
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
