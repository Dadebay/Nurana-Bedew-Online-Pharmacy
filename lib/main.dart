// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medicine_app/utils/translations.dart';
import 'package:medicine_app/views/auth/connection_check.dart';

import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    statusBarColor: kPrimaryColor,
  ));
  //set device only Portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(GetMaterialApp(
    locale: const Locale('en'),
    translations: MyTranslations(),
    defaultTransition: Transition.cupertinoDialog,
    debugShowCheckedModeBanner: false,
    home: ConnectionCheck(),
  ));
}
