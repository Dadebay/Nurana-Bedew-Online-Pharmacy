// ignore_for_file: file_names, implementation_imports

import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Others/Models/CartModel.dart';
import '../Others/constants/constants.dart';
import '../Others/constants/widgets.dart';
import 'HomePage/ProductProfil/ProductProfil.dart';

class ProductCard extends StatefulWidget {
  final int id;
  final String imagePath;
  final String name;
  final int price;
  final int cardId;
  final int stockCount;

  const ProductCard(
      {Key key,
      this.id,
      this.imagePath,
      this.name,
      this.price,
      this.cardId,
      this.stockCount})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool addCart = false;
  int quantity = 1;

  removeQuantity() {
    int a = quantity - 1;
    setState(() {
      if (quantity != 0) {
        quantity -= 1;
        if (quantity == 0) addCart = false;
      }
    });
  }

  addQuantity() {
    final int a = widget.stockCount;
    final int b = quantity + 1;
    if (a > b) {
      setState(() {
        quantity += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Material(
        elevation: 4,
        borderRadius: borderRadius10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey[200], borderRadius: borderRadius10),
              child: ClipRRect(
                  borderRadius: borderRadius5,
                  child: image(
                    "$serverImage/${widget.imagePath}-mini.webp",
                  )),
            )),
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
                  const Text(
                    "price",
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: popPinsRegular,
                        fontSize: 14),
                  ).tr(),
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
                setState(() {
                  addCart = true;
                });
              },
              child: addCart
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              removeQuantity();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle),
                              child: const FittedBox(
                                child: Icon(
                                  Icons.remove,
                                  color: kPrimaryColor,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "${quantity}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: popPinsMedium),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              addQuantity();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle),
                              child: const FittedBox(
                                child: Icon(
                                  Icons.add,
                                  color: kPrimaryColor,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: size.width,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                          color: kPrimaryColor, borderRadius: borderRadius10),
                      child: const Text(
                        "addCartTitle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontFamily: popPinsMedium),
                      ).tr()),
            )
          ],
        ),
      ),
    );
  }
}
