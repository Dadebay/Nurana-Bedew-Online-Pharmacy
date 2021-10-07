// ignore_for_file: avoid_positional_boolean_parameters, implementation_imports, prefer_const_constructors, deprecated_member_use

import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/BottomNavBar/BottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Others/constants/constants.dart';

class ConnectionCheck extends StatefulWidget {
  @override
  _ConnectionCheckState createState() => _ConnectionCheckState();
}

class _ConnectionCheckState extends State<ConnectionCheck> {
  ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();
    setData();
    checkConnection();
  }

  bool firsttime = false;

  Future<bool> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("firstTime");
  }

  void setData() {
    setState(() {
      loadData().then((value) {
        firsttime = value ?? false;
      });
    });
  }

  void checkConnection() {
    try {
      InternetAddress.lookup('google.com').then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Future.delayed(Duration(milliseconds: 2000), () {
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (_) => BottomNavBar()));
          });
        } else {
          _showDialog();
        }
      }).catchError((error) {
        _showDialog();
      });
    } on SocketException catch (_) {
      _showDialog();
    }
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connrresult) {
      if (connrresult == ConnectivityResult.none) {
      } else if (_connectivityResult == ConnectivityResult.none) {
        Future.delayed(Duration(milliseconds: 2000), () {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (_) => BottomNavBar()));
        });
      }
      _connectivityResult = connrresult;
    });
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
                            'Aragatnaşyk ýok',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: kPrimaryColor,
                              fontFamily: popPinsSemiBold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Text(
                              'Internede baglanyp bolmady.Internet sazlamalryňyzy barlap gaýtadan synanşyň !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: popPinsMedium,
                                fontSize: 16.0,
                              ),
                            ),
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
                child: FlutterLogo(
              size: 300,
            )),
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
