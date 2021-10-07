// ignore_for_file: file_names, implementation_imports, deprecated_member_use

import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/BottomNavBar/HomePage/ProductProfil/ProductProfil.dart';
import 'package:medicine_app/Others/Models/CartModel.dart';
import 'package:medicine_app/Others/Models/NotificationModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBarBackButton(context, "notificationName"),
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
                      child: Container(
                        height: size.height,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: borderRadius15),
                        child: ClipRRect(
                          borderRadius: borderRadius15,
                          child: image(
                            "$serverImage/${product.image}-mini.webp",
                          ),
                        ),
                      )),
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
                                const Text(
                                  "Bahasy : ",
                                  style: TextStyle(
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
                          Container(
                            width: size.width,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: RaisedButton(
                                onPressed: () async {
                                  await CartModel().addToCart(
                                      id: product.productId,
                                      parametrs: {
                                        "quantity": jsonEncode(1)
                                      }).then((value) {
                                    if (value == true) {
                                      showMessage("addCart", context);
                                    } else {
                                      showMessage("tryagain", context);
                                    }
                                  });
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: borderRadius15,
                                ),
                                color: kPrimaryColor,
                                elevation: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(IconlyLight.bag,
                                          color: Colors.white, size: 25),
                                    ),
                                    const Text(
                                      "addCartTitle",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, //kPrimaryColor,
                                          fontFamily: popPinsMedium,
                                          fontSize: 16),
                                    ).tr(),
                                  ],
                                )),
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
