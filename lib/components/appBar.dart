// ignore_for_file: file_names, avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/views/HomePage/SearchPage.dart';

class MyAppBar extends StatelessWidget implements PreferredSize {
  final String name;
  final IconData icon;
  final Function() onTap;
  final bool backArrow;
  const MyAppBar({Key key, this.name, this.icon, this.backArrow, this.onTap})
      : super(key: key);

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: backArrow
            ? IconButton(
                icon: const Icon(IconlyLight.arrowLeft2),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(icon),
              onPressed: () {
                Get.to(() => const Search(newInCome: '0'));
              },
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
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: popPinsMedium),
        ),
      ),
    );
  }

  @override
  Widget get child => const Text("ad");

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
