import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/noItem.png",
            color: kPrimaryColor,
            fit: BoxFit.contain,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 15),
            child: Text(
              "cartEmpty".tr,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
            ),
          ),
          Text(
            "cartEmptySubtitle".tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: montserratMedium),
          ),
        ],
      ),
    );
  }
}
