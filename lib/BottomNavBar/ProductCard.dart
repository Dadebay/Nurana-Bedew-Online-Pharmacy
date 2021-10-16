// ignore_for_file: file_names, implementation_imports, unnecessary_statements, always_declare_return_types, type_annotate_public_apis, avoid_print, deprecated_member_use, invariant_booleans


import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/Others/Models/NotificationModel.dart';

import '../Others/constants/constants.dart';
import '../Others/constants/widgets.dart';
import 'HomePage/ProductProfil/ProductProfil.dart';

class ProductCard extends StatefulWidget {
  final int id;
  final String imagePath;
  final String name;
  final String price;
  final int stockCount;
  final bool addCart;
  final int cartQuantity;

  const ProductCard(
      {this.id,
      this.imagePath,
      this.name,
      this.price,
      this.stockCount,
      this.addCart,
      this.cartQuantity});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;
  bool redCard = false;
  bool bildir = false;
  @override
  void initState() {
    super.initState();
    quantity = widget.cartQuantity;
    redCard = false;
    if (widget.stockCount < widget.cartQuantity && bildir == false) {
      redCard = true;
    }
    if (widget.stockCount == 0) bildir = true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                ProductProfil(drugID: widget.id, quantity: quantity)));
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
                      child: image(
                          "$serverImage/${widget.imagePath}-mini.webp", size)),
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
                          habarET();
                        } else {
                          quantity += 1;
                          saveData(widget.id, quantity);
                        }
                      });
                    },
                    child: quantity != 0
                        ? Container(
                            width: size.width,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: borderRadius10),
                            child: const Text(
                              "addCart",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: popPinsMedium),
                            ).tr())
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
                                  color: Colors.white,
                                  fontFamily: popPinsMedium),
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
                            // saveData(widget.id, widget.stockCount);
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
                      Navigator.of(context).pop();

                      showMessage(
                          "notificationSend", context, Colors.green.shade500);
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
