// ignore_for_file: file_names, implementation_imports, unnecessary_statements, always_declare_return_types, type_annotate_public_apis, avoid_print, deprecated_member_use, invariant_booleans

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/views/HomePage/ProductProfil/ProductProfil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final int id;
  final String imagePath;
  final String name;
  final String price;
  final int stockCount;
  final bool addCart;
  final int cartQuantity;
  final int refreshPage;

  const ProductCard(
      {this.id,
      this.imagePath,
      this.name,
      this.price,
      this.stockCount,
      this.addCart,
      this.cartQuantity,
      @required this.refreshPage});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool redCard = false;
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    if (widget.stockCount < widget.cartQuantity) {
      redCard = true;
    }
    quantity = widget.cartQuantity;

    myList.forEach((element) {
      if (element["id"] == widget.id) quantity = element["cartQuantity"];
    });
  }

  saveData(int id, int quantity) async {
    bool value = false;
    if (quantity == 0) {
      myList.removeWhere((element) => element["id"] == id);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedMap = json.encode(myList);
      prefs.setString('cart', encodedMap);
    } else {
      for (final element in myList) {
        if (element["id"] == id) {
          setState(() {
            element["cartQuantity"] = quantity;
          });
          value = true;
        }
      }

      if (value == false) myList.add({"id": id, "cartQuantity": quantity});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedMap = json.encode(myList);

      prefs.setString('cart', encodedMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductProfil(
              drugID: widget.id,
              quantity: quantity,
              refreshPage: widget.refreshPage,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Stack(
          children: [
            Material(
              elevation: 4,
              borderRadius: borderRadius10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: image("$serverImage/${widget.imagePath}-mini.webp",
                          Get.size)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: popPinsMedium),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          "price".tr,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: popPinsRegular,
                              fontSize: 14),
                        ),
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: " ${widget.price}",
                                  style: const TextStyle(
                                      fontFamily: popPinsMedium,
                                      fontSize: 18,
                                      color: Colors.black)),
                              const TextSpan(
                                  text: " TMT",
                                  style: TextStyle(
                                      fontFamily: popPinsMedium,
                                      fontSize: 12,
                                      color: Colors.black))
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.stockCount == 0) {
                        habarEt2(widget.id, context);
                      } else {
                        setState(() {
                          if ((quantity + 1) <= widget.stockCount) {
                            if (quantity == 0) quantity += 1;
                            saveData(widget.id, 1);
                          } else {
                            showMessage(
                                "emptyStockMin".tr, context, Colors.red);
                          }
                        });
                      }
                    },
                    child: quantity != 0
                        ? Container(
                            width: Get.size.width,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: borderRadius10),
                            child: Text(
                              "addCart".tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: popPinsMedium),
                            ))
                        : Container(
                            width: Get.size.width,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: widget.stockCount == 0
                                    ? Colors.red
                                    : kPrimaryColor,
                                borderRadius: borderRadius10),
                            child: Text(
                              widget.stockCount == 0
                                  ? "notification".tr
                                  : "addCartTitle".tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: popPinsMedium),
                            )),
                  )
                ],
              ),
            ),
            if (redCard)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: borderRadius10,
                    color: Colors.black.withOpacity(0.6),
                    border: Border.all(color: Colors.red, width: 2)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "minStockCount".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: popPinsMedium, color: Colors.white),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            redCard = false;
                          });
                        },
                        color: kPrimaryColor,
                        child: const Text("Azalt",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: popPinsMedium)),
                      )
                    ],
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
