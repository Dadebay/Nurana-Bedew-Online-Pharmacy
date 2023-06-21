// ignore_for_file: directives_ordering, join_return_with_assignment, non_constant_identifier_names, always_use_package_imports

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine_app/utils/translations.dart';
import 'package:medicine_app/views/auth/view/connection_check.dart';
import 'package:medicine_app/views/cart_view/controller/cart_view_controller.dart';

import 'constants/constants.dart';
import 'constants/notification_service.dart';

Future backgroundNotificationHandler(RemoteMessage message) async {
  await FCMConfig().sendNotification(body: message.notification!.body!, title: message.notification!.title!);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await FCMConfig().requestPermission();
  await FCMConfig().initAwesomeNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    statusBarColor: kPrimaryColor,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyRunApp());
}

class MyRunApp extends StatefulWidget {
  @override
  State<MyRunApp> createState() => _MyRunAppState();
}

class _MyRunAppState extends State<MyRunApp> {
  final storage = GetStorage();
  final CartViewController cartViewController = Get.put(CartViewController());
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('Events');
    FCMConfig().requestPermission();
    cartViewController.returnCartList();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FCMConfig().sendNotification(body: message.notification!.body!, title: message.notification!.title!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      fallbackLocale: const Locale('tr'),
      locale: storage.read('langCode') != null
          ? Locale(storage.read('langCode'))
          : const Locale(
              'tr',
            ),
      translations: MyTranslations(),
      theme: ThemeData(useMaterial3: true),
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
      home: ConnectionCheckView(),
    );
  }
}
