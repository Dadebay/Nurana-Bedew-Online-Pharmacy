// ignore_for_file: file_names, implementation_imports, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/data/services/notification_service.dart';

import '../../constants/app_bar_static.dart';
import '../../constants/cards/waiting_product_card.dart';
import '../../data/models/notification_model.dart';

class WaitingProductsView extends StatefulWidget {
  @override
  _WaitingProductsViewState createState() => _WaitingProductsViewState();
}

class _WaitingProductsViewState extends State<WaitingProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          backArrow: true,
          name: "notificationName",
          onTap: () {},
        ),
        body: FutureBuilder<List<NotificationModel>>(
            future: NotificationService().getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return spinKit();
              } else if (snapshot.hasError) {
                return const Icon(Icons.refresh, color: kPrimaryColor, size: 35);
              } else if (snapshot.data!.isEmpty) {
                return Center(child: Text("notificationNameSubtitle".tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: montserratSemiBold, color: Colors.black, fontSize: 18)));
              }
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
                  itemBuilder: (BuildContext context, int index) {
                    return WaitingProductCard(
                      product: snapshot.data![index],
                    );
                  });
            }));
  }
}
