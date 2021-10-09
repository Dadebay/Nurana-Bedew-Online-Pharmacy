// ignore_for_file: file_names, implementation_imports, unnecessary_statements, always_declare_return_types, type_annotate_public_apis, avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/Others/Models/NotificationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Others/constants/constants.dart';
import '../Others/constants/widgets.dart';
import 'HomePage/ProductProfil/ProductProfil.dart';

class ProductCard extends StatefulWidget {
  final int id;
  final String imagePath;
  final String name;
  final int price;
  final int stockCount;
  final int cartQuantity;
  final bool addCart;

  const ProductCard({
    Key key,
    this.id,
    this.imagePath,
    this.name,
    this.price,
    this.stockCount,
    this.addCart,
    this.cartQuantity,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool addCart = false;
  int quantity = 1;
  bool redCard = false;
  bool bildir = false;
  @override
  void initState() {
    super.initState();
    addCart = widget.addCart ?? false;
    quantity = 1;
    redCard = false;
    if (widget.stockCount < widget.cartQuantity && bildir == false) {
      redCard = true;
    }
    if (widget.stockCount == 0) bildir = true;
    for (final element in myList) {
      if (element["id"] == widget.id) {
        quantity = element["cartQuantity"];
      }
    }
  }

  saveData(int id, int quantity) async {
    bool value = false;
    if (quantity == 0) {
      myList.removeWhere((element) => element["id"] == id);
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
      print(encodedMap);
    }
  }

  removeQuantity() {
    if (quantity != 0) {
      setState(() {
        quantity -= 1;

        saveData(widget.id, quantity);

        if (quantity == 0) addCart = false;
      });
    }
  }

  addQuantity() {
    int a = widget.stockCount;
    int b = quantity + 1;
    print(a);
    (b);
    if (a > b) {
      setState(() {
        quantity += 1;
        saveData(widget.id, quantity);
      });
    } else {
      showMessage("Haryt Ammarda Yok", context, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
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
                      if (widget.stockCount == 0) {
                        addCart = false;
                        habarET();
                      } else {
                        addCart = true;
                        saveData(widget.id, quantity);
                      }
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "$quantity",
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
                          decoration: BoxDecoration(
                              color: bildir ? Colors.red : kPrimaryColor,
                              borderRadius: borderRadius10),
                          child: Text(
                            bildir ? "notification" : "addCartTitle",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontFamily: popPinsMedium),
                          ).tr()),
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
                    const Text(
                      "Sebediňizdäki harydyň sany Ammardaky derman sanyndan az. Derman sanyny azaltmagyňyzy haýyşt edýäris.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: popPinsMedium, color: Colors.white),
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          saveData(widget.id, widget.stockCount);
                          redCard = false;
                        });
                      },
                      color: kPrimaryColor,
                      child: const Text("Azalt",
                          style: TextStyle(
                              color: Colors.white, fontFamily: popPinsMedium)),
                    )
                  ],
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  habarET() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'noProduct',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontFamily: popPinsMedium),
              ).tr(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: const Text(
                  'noProductTitle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: popPinsRegular,
                      fontSize: 16),
                ).tr(),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    elevation: 1,
                    shape: const RoundedRectangleBorder(
                        borderRadius: borderRadius10,
                        side: BorderSide(color: kPrimaryColor, width: 2)),
                    color: kPrimaryColor,
                    child: const Text(
                      'yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: popPinsSemiBold),
                    ).tr(),
                    onPressed: () {
                      NotificationModel().addNotification(widget.id);
                      showMessage(
                          "Habar ugradyl", context, Colors.green.shade500);
                    }),
                RaisedButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: borderRadius10,
                        side: BorderSide(color: kPrimaryColor, width: 2)),
                    color: kPrimaryColor,
                    child: const Text(
                      'no',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: popPinsSemiBold),
                    ).tr(),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        );
      },
    );
  }
}
