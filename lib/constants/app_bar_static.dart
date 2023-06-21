// ignore_for_file: file_names, avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSize {
  final String name;
  final IconData? icon;
  final Function() onTap;
  final bool backArrow;
  const MyAppBar({required this.name, this.icon, required this.backArrow, required this.onTap});

  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: kPrimaryColor, statusBarBrightness: Brightness.dark),
        elevation: 0.0,
        centerTitle: true,
        leading: backArrow
            ? IconButton(
                icon: const Icon(
                  IconlyLight.arrowLeftCircle,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              )
            : const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(icon),
              color: Colors.white,
              onPressed: onTap,
            ),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          name.tr,
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratMedium),
        ),
      ),
    );
  }

  @override
  Widget get child => const Text("ad");

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
