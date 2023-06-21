import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/views/cart_view/views/order_view.dart';

import '../constants.dart';

class GoToOrderViewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      onPressed: () {
        Get.to(() => OrderView());
      },
      backgroundColor: kPrimaryColor,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "order".tr,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              IconlyLight.arrowRightCircle,
              size: 20,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
