// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_await_in_return, implementation_imports, non_constant_identifier_names, file_names, type_annotate_public_apis, use_build_context_synchronously, always_declare_return_types, avoid_positional_boolean_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/models/AuthModel.dart';
import 'package:medicine_app/views/auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HistoryOrders.dart';
import 'NotificationPage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String phoneNumber = "";
  String username = "";
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getTokenMine();
    Future.delayed(Duration(milliseconds: 200), () {
      setData();
    });
  }

  Future<String> getUsername() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('name');
  }

  Future<String> getPhoneNumber() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('phone');
  }

  setData() {
    getUsername().then((value) {
      setState(() {
        username = value ?? "Nurana Bedew";
      });
    });
    getPhoneNumber().then((value) {
      setState(() {
        phoneNumber = value ?? "65555555";
        loading = true;
      });
    });
  }

  Future<bool> saveDataFirstTime(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool("firstTime", value);
  }

  Future<dynamic> log_out(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        "log_out".tr,
                        style: const TextStyle(color: Colors.black, fontFamily: popPinsSemiBold, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(CupertinoIcons.xmark_circle_fill, size: 35, color: Colors.grey[300]),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text("log_out_title".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: popPinsMedium,
                        fontSize: 18,
                      )),
                ),
                GestureDetector(
                  onTap: () async {
                    await Auth().logout();
                    await Auth().removeToken();
                    await Auth().removeRefreshToken();
                    saveDataFirstTime(false);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Login()));
                  },
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius10),
                    child: Text(
                      "log_out_yes".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontFamily: popPinsBold, fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius10),
                    child: Text(
                      "log_out_no".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container logoPart() {
    return Container(
      height: 150,
      width: 150,
      margin: EdgeInsets.only(top: 40, bottom: 25),
      decoration: BoxDecoration(
        borderRadius: borderRadius30,
      ),
      child: Image.asset(
        "assets/images/diller/logo.png",
        fit: BoxFit.fill,
      ),
    );
  }

  Future<dynamic> changeLanguage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        "select_language".tr,
                        style: const TextStyle(color: Colors.black, fontFamily: popPinsSemiBold, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(CupertinoIcons.xmark_circle_fill, size: 35, color: Colors.grey[300]),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                    onTap: () {
                      Get.updateLocale(Locale('en'));
                      Get.back();
                    },
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/diller/tm.png',
                      ),
                      radius: 20,
                    ),
                    title: textBlck(text: 'Türkmen')),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ListTile(
                      onTap: () {
                        Get.updateLocale(Locale('ru'));
                        Get.back();
                      },
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/diller/ru.png',
                        ),
                        radius: 20,
                      ),
                      title: textBlck(text: 'Русский')),
                ),
              ],
            ),
          );
        });
  }

  String token = null;
  getTokenMine() async {
    final token1 = await Auth().getToken();
    token = token1;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(name: "profil", backArrow: false),
      body: loading
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logoPart(),
                  Text(
                    username.tr,
                    style: TextStyle(color: Colors.black, fontFamily: popPinsSemiBold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: Text(
                      "+993-$phoneNumber".tr,
                      style: TextStyle(color: Colors.black54, fontFamily: popPinsMedium, fontSize: 16),
                    ),
                  ),
                  buttonProfile(
                      name: "notificationName",
                      icon: IconlyLight.notification,
                      onTap: () {
                        Get.to(() => NotificationPage());
                      }),
                  buttonProfile(
                      name: "orders",
                      icon: IconlyLight.paper,
                      onTap: () {
                        Get.to(() => HistoryOrder());
                      }),
                  buttonProfile(
                      name: "language",
                      icon: Icons.language_outlined,
                      onTap: () {
                        changeLanguage(context); //languagePicker();
                      }),
                  buttonProfile(
                      name: token == null ? "login" : "log_out",
                      icon: token == null ? IconlyLight.login : IconlyLight.logout,
                      onTap: () async {
                        if (token == null) {
                          Get.to(() => Login());
                        } else {
                          log_out(context, size);
                        }
                      }),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )
          : spinKit(),
    );
  }
}
