// ignore_for_file: file_names, implementation_imports, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/models/NotificationModel.dart';
import 'package:medicine_app/views/HomePage/ProductProfil/ProductProfil.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: const MyAppBar(backArrow: true, name: "notificationName"),
          body: FutureBuilder<List<NotificationModel>>(
              future: NotificationModel().getAllNotificationModels(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cartCard(snapshot.data[index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Icon(
                      Icons.refresh,
                      size: 35,
                      color: kPrimaryColor,
                    ),
                  );
                }
                return Center(
                  child: spinKit(),
                );
              })),
    );
  }

  Widget cartCard(NotificationModel product) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductProfil(
                  drugID: product.productId,
                  quantity: null,
                )));
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Material(
            elevation: 1,
            borderRadius: borderRadius15,
            color: Colors.white,
            child: Container(
              height: 160,
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: borderRadius15),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child:
                        image("$serverImage/${product.image}-mini.webp", size),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: popPinsMedium,
                                      fontSize: 18),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  NotificationModel()
                                      .removeNotification(
                                          product.notificationId)
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: const Icon(CupertinoIcons.xmark_circle,
                                    color: kPrimaryColor, size: 25),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(
                                  "price".tr,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontFamily: popPinsRegular,
                                      fontSize: 14),
                                ),
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: product.price,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: popPinsMedium),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: ' TMT ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: popPinsMedium),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
