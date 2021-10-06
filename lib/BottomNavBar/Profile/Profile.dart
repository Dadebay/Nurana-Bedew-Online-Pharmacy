// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_await_in_return, implementation_imports, non_constant_identifier_names, file_names, type_annotate_public_apis, use_build_context_synchronously, always_declare_return_types

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/Others/Models/AuthModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NotificationPage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String phoneNumber = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    setData();
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
        username = value;
      });
    });
    getPhoneNumber().then((value) {
      setState(() {
        phoneNumber = value;
      });
    });
  }

  Future<dynamic> log_out(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 350,
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: borderRadius10, color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      const Text(
                        "log_out",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: popPinsSemiBold,
                            fontSize: 18),
                      ).tr(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(CupertinoIcons.xmark_circle_fill,
                            size: 35, color: Colors.grey[300]),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("log_out_title",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: popPinsMedium,
                        fontSize: 18,
                      )).tr(),
                ),
                GestureDetector(
                  onTap: () async {
                    await Auth().logout();
                    await Auth().removeToken();
                    await Auth().removeRefreshToken();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.red, borderRadius: borderRadius10),
                    child: const Text(
                      "log_out_yes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: popPinsBold,
                          fontSize: 18),
                    ).tr(),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey[100], borderRadius: borderRadius10),
                    child: const Text(
                      "log_out_no",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: popPinsMedium,
                          fontSize: 18),
                    ).tr(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container logoPart() {
    return Container(
      height: 115,
      width: 115,
      margin: EdgeInsets.only(top: 40, bottom: 25),
      decoration:
          BoxDecoration(borderRadius: borderRadius30, color: kPrimaryColor),
    );
  }

  Future<bool> saveData(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(langKey, value);
  }

  Future<dynamic> changeLanguage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: borderRadius10, color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      const Text(
                        "select_language",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: popPinsSemiBold,
                            fontSize: 18),
                      ).tr(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(CupertinoIcons.xmark_circle_fill,
                            size: 35, color: Colors.grey[300]),
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
                      saveData("tm");
                      Navigator.of(context).pop();
                      setState(() {
                        context.locale = const Locale("en", "US");
                      });
                    },
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/diller/tm.png',
                      ),
                      radius: 20,
                    ),
                    title: textBlck(text: 'Türkmen')),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                    onTap: () {
                      saveData("ru");
                      Navigator.of(context).pop();

                      setState(() {
                        context.locale = const Locale("ru", "RU");
                      });
                    },
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/diller/ru.png',
                      ),
                      radius: 20,
                    ),
                    title: textBlck(text: 'Русский')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("profil"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoPart(),
            Text(
              username,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: popPinsSemiBold,
                  fontSize: 20),
            ).tr(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                "+993-$phoneNumber",
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: popPinsMedium,
                    fontSize: 16),
              ).tr(),
            ),
            buttonProfile(
                name: "notificationName",
                icon: IconlyLight.notification,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => NotificationPage()));
                }),
            buttonProfile(
                name: "language",
                icon: Icons.language_outlined,
                onTap: () {
                  changeLanguage(context); //languagePicker();
                }),
            buttonProfile(
                name: "log_out",
                icon: IconlyLight.logout,
                onTap: () {
                  log_out(context, size);
                }),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
