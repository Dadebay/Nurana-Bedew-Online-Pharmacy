import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/order_model.dart';
import '../../views/user_profile/ordered_product_profil_view.dart';
import '../constants.dart';

class OrderedProductsCard extends StatelessWidget {
  const OrderedProductsCard({Key? key, required this.model, required this.index}) : super(key: key);
  final OrdersModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.all(10),
        ),
        onPressed: () {
          Get.to(() => OrderedProductProfilView(
                index: index + 1,
                id: model.id!,
              ));
        },
        child: Row(
          children: [
            Expanded(
              child: Text("${"orderHistory".tr} ${index + 1}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontFamily: montserratSemiBold,
                    color: Colors.black,
                  )),
            ),
            Expanded(
              child: Text(model.createdAt!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontFamily: montserratRegular)),
            ),
            Expanded(
              child: Text(
                "${model.totalPrice} " + "TMT",
                textAlign: TextAlign.end,
                style: const TextStyle(fontFamily: montserratMedium, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
