// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/views/home_view/controllers/home_view_controller.dart';

class AgreeButton extends StatelessWidget {
  final Function() onTap;

  AgreeButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: animatedContaner());
  }

  final HomeViewController homePageController = Get.put(HomeViewController());

  Widget animatedContaner() {
    return Obx(() {
      return AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: borderRadius10,
          color: kPrimaryColor,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: homePageController.agreeButton.value ? 0 : 10),
        width: homePageController.agreeButton.value ? 60 : Get.size.width,
        duration: const Duration(milliseconds: 1000),
        child: homePageController.agreeButton.value
            ? const Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                'agree'.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 20),
              ),
      );
    });
  }
}
