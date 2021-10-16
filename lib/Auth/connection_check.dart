// ignore_for_file: avoid_positional_boolean_parameters, implementation_imports, prefer_const_constructors, deprecated_member_use, avoid_void_async

import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/BottomNavBar/BottomNavBar.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Others/constants/constants.dart';
import 'Login.dart';

class ConnectionCheck extends StatefulWidget {
  @override
  _ConnectionCheckState createState() => _ConnectionCheckState();
}

class _ConnectionCheckState extends State<ConnectionCheck> {
  @override
  void initState() {
    super.initState();
    setData();
    checkConnection();
  }

  bool firsttime = false;

  Future<bool> loadDataFirstTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("firstTime");
  }

  Future<bool> saveData(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(langKey, value);
  }

  Future<String> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(langKey);
  }

  void setData() {
    setState(() {
      loadDataFirstTime().then((value) {
        firsttime = value ?? false;
      });
    });
  }

  Future langSelect() => showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(
                  borderSide: BorderSide.none, borderRadius: borderRadius10),
              title: const Text(
                "select_language",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: popPinsSemiBold,
                    fontSize: 20),
              ).tr(),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      onTap: () {
                        firsttime
                            ? Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        BottomNavBar()))
                            : Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        Login()));
                        saveData("tm");
                        setState(() {
                          context.locale = Locale("en", "US");
                        });
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/diller/tm.png',
                        ),
                        radius: 20,
                      ),
                      title: textBlck(text: 'Türkmen')),
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                      onTap: () {
                        firsttime
                            ? Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        BottomNavBar()))
                            : Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        Login()));
                        saveData("ru");
                        setState(() {
                          context.locale = Locale("ru", "RU");
                        });
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/diller/ru.png',
                        ),
                        radius: 20,
                      ),
                      title: textBlck(text: 'Русский')),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 500),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return null;
      });

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (firsttime == false) {
          langSelect();
        } else {
          Future.delayed(Duration(milliseconds: 2000), () {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (BuildContext context) => BottomNavBar()));
          });
        }
      }
    } on SocketException catch (_) {
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: borderRadius20),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      padding: EdgeInsets.only(top: 100),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: borderRadius20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'noConnection1',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: kPrimaryColor,
                              fontFamily: popPinsSemiBold,
                            ),
                          ).tr(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Text(
                              'noConnection2',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: popPinsMedium,
                                fontSize: 16.0,
                              ),
                            ).tr(),
                          ),
                          RaisedButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: borderRadius10),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Future.delayed(Duration(milliseconds: 1000), () {
                                checkConnection();
                              });
                            },
                            child: Text(
                              "Täzeden barla",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: popPinsSemiBold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 70,
                      minRadius: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          child: Image.asset(
                            "assets/icons/noconnection.gif",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  checkConnection();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset('assets/images/diller/logo.png',
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300], color: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
