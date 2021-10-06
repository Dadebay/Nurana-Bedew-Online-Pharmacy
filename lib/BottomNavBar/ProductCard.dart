// ignore_for_file: file_names, implementation_imports

import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import '../Others/Models/CartModel.dart';
import '../Others/constants/constants.dart';
import '../Others/constants/widgets.dart';
import 'HomePage/ProductProfil/ProductProfil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key key, this.name, this.price, this.imagePath, this.id})
      : super(key: key);

  final int id;
  final String imagePath;
  final String name;
  final int price;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductProfil(
                  drugID: id,
                )));
      },
      child: Container(
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
                    child: image("$serverImage/$image-mini.webp", size)),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  name,
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
                          color: Colors.red,
                          fontFamily: popPinsRegular,
                          fontSize: 14),
                    ).tr(),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: " $price",
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
                  CartModel().addToCart(
                      id: id,
                      parametrs: {"quantity": jsonEncode(1)}).then((value) {
                    if (value == true) {
                      showMessage("addCart", context);
                    } else {
                      showMessage("tryagain", context);
                    }
                  });
                },
                child: Container(
                    width: size.width,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
      ),
    );
  }
}
