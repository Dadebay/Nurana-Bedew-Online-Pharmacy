// ignore_for_file: file_names, avoid_positional_boolean_parameters, avoid_void_async, always_declare_return_types, always_use_package_imports

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/dialogs/connection_check_dialog_view.dart';
import 'package:medicine_app/data/services/auth_service.dart';

import '../../bottom_nav_bar.dart';
import 'login_view.dart';

class ConnectionCheckView extends StatefulWidget {
  @override
  _ConnectionCheckViewState createState() => _ConnectionCheckViewState();
}

class _ConnectionCheckViewState extends State<ConnectionCheckView> {
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String token = await Auth().getToken();
        Future.delayed(const Duration(milliseconds: 2000), () {
          Get.to(() => token == '' ? LoginView() : BottomNavBar());
        });
      }
    } on SocketException catch (_) {
      connectionCheckDialog();
    }
  }

  void connectionCheckDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ConnectionCheckViewDialog(retryButtonTap: () {
              Navigator.of(context).pop();
              Future.delayed(const Duration(milliseconds: 1000), () {
                checkConnection();
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: Center(child: Image.asset("assets/icons/logo.png", height: 250, width: 250, fit: BoxFit.cover))),
          LinearProgressIndicator(
            color: kPrimaryColor,
            backgroundColor: Colors.grey.shade200,
          )
        ],
      ),
    );
  }
}
