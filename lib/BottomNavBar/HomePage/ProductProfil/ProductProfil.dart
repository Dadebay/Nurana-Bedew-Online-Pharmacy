// ignore_for_file: implementation_imports, deprecated_member_use, file_names, unnecessary_string_interpolations, avoid_bool_literals_in_conditional_expressions, type_annotate_public_apis, always_declare_return_types, unnecessary_statements

import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/BottomNavBar/BottomNavBar.dart';
import 'package:medicine_app/Others/Models/NotificationModel.dart';
import 'package:medicine_app/Others/Models/ProductProfilModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PhotoView.dart';

class ProductProfil extends StatefulWidget {
  const ProductProfil({Key key, this.drugID, @required this.quantity})
      : super(key: key);

  final int drugID;
  final int quantity;

  @override
  _ProductProfilState createState() => _ProductProfilState();
}

class _ProductProfilState extends State<ProductProfil> {
  bool orderButtonChange = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    setData();
    quantity = widget.quantity ?? 0;

    orderButtonChange = widget.quantity == 0 ? false : true;
  }

  Widget hasData(Size size, BuildContext context, ProductModel product) {
    return CustomScrollView(
      slivers: [
        imagePart(size, "$serverImage/${product.images}-big.webp",
            "${product.productName}"),
        SliverList(
            delegate: SliverChildListDelegate([
          dividerr(),
          dividerr(),
          dividerr(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Text(
              "${product.productName}",
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: popPinsSemiBold,
                  fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Text(
                  "price",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: popPinsMedium,
                      fontSize: 18),
                ).tr(),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: " ${product.price}",
                          style: const TextStyle(
                              fontFamily: popPinsSemiBold,
                              fontSize: 20,
                              color: Colors.black)),
                      const TextSpan(
                          text: " TMT",
                          style: TextStyle(
                              fontFamily: popPinsSemiBold,
                              fontSize: 16,
                              color: Colors.black))
                    ]),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "dateOfExpire",
                  style: TextStyle(
                      color: Colors.black38,
                      fontFamily: popPinsMedium,
                      fontSize: 16),
                ).tr(),
                Expanded(
                  child: Text(
                    "${product.dateOfExpire.substring(0, 10)}",
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: popPinsMedium,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "quantity",
                  style: TextStyle(
                      color: Colors.black38,
                      fontFamily: popPinsMedium,
                      fontSize: 16),
                ).tr(),
                Expanded(
                  child: Text(
                    "${product.quantity}",
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: popPinsMedium,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "country",
                  style: TextStyle(
                      color: Colors.black38,
                      fontFamily: popPinsMedium,
                      fontSize: 16),
                ).tr(),
                Expanded(
                  child: Text(
                    "${product.categoryName}",
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: popPinsMedium,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "category",
                  style: TextStyle(
                      color: Colors.black38,
                      fontFamily: popPinsMedium,
                      fontSize: 16),
                ).tr(),
                Expanded(
                  child: Text(
                    "${product.categoryName}",
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: popPinsMedium,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          if (lang == "tm")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ExpansionTile(
                title: const Text("descriptionTm",
                        style:
                            TextStyle(fontFamily: popPinsMedium, fontSize: 17))
                    .tr(),
                textColor: kPrimaryColor,
                collapsedTextColor: Colors.grey,
                iconColor: kPrimaryColor,
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  Text(
                    "${product.descriptionTm}",
                    style: const TextStyle(
                        color: Colors.black, fontFamily: popPinsRegular),
                  )
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ExpansionTile(
                title: const Text("descriptionRu",
                        style:
                            TextStyle(fontFamily: popPinsMedium, fontSize: 17))
                    .tr(),
                textColor: kPrimaryColor,
                collapsedTextColor: Colors.grey,
                iconColor: kPrimaryColor,
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  Text(
                    "${product.descriptionRu}",
                    style: const TextStyle(
                        color: Colors.black, fontFamily: popPinsRegular),
                  )
                ],
              ),
            ),
          const SizedBox(
            height: 80,
          )
        ]))
      ],
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
                      NotificationModel().addNotification(widget.drugID);
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

  saveData(int id, int quantity) async {
    bool value = false;
    if (quantity == 0) {
      myList.removeWhere((element) => element["id"] == id);
    } else {
      for (final element in myList) {
        if (element["id"] == id) {
          element["cartQuantity"] = quantity;
          value = true;
        }
      }

      if (value == false) myList.add({"id": id, "cartQuantity": quantity});

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedMap = json.encode(myList);
      prefs.setString('cart', encodedMap);
    }
  }

  removeQuantity(ProductModel product) {
    if (quantity != 0) {
      setState(() {
        quantity -= 1;
        final int id = int.parse(product.id);

        saveData(id, quantity);

        if (quantity == 0) orderButtonChange = false;
      });
    }
  }

  addQuantity(ProductModel product, BuildContext context) {
    if (product.stockCount > (quantity + 1)) {
      setState(() {
        quantity += 1;
        final int id = int.parse(product.id);
        saveData(id, quantity);
      });
    } else {
      showMessage("Haryt Ammarda Yok", context, Colors.red);
    }
  }

  Widget orderButton({String name, bool icon, ProductModel product}) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: orderButtonChange
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      removeQuantity(product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.grey[200], shape: BoxShape.circle),
                      child: const FittedBox(
                        child: Icon(
                          Icons.remove,
                          color: kPrimaryColor,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "$quantity",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontFamily: popPinsMedium),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addQuantity(product, context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.grey[200], shape: BoxShape.circle),
                      child: const FittedBox(
                        child: Icon(Icons.add, color: kPrimaryColor, size: 35),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : RaisedButton(
              onPressed: () {
                setState(() {
                  if (icon == false) {
                  } else {
                    orderButtonChange = true;
                  }
                });
                icon ? null : habarET();
              },
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: borderRadius15,
              ),
              color: icon ? kPrimaryColor : Colors.red,
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(icon ? IconlyLight.bag : IconlyLight.infoSquare,
                        color: Colors.white, size: 25),
                  ),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, //kPrimaryColor,
                        fontFamily: popPinsMedium,
                        fontSize: 18),
                  ).tr(),
                ],
              )),
    );
  }

  Widget imagePart(Size size, String imageString, String name) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
        child: GestureDetector(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => BottomNavBar()));
          },
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: borderRadius15),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                IconlyLight.arrowLeft2,
                color: Colors.black,
              )),
        ),
      ),
      pinned: true,
      toolbarHeight: 60,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final top = constraints.biggest.height;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: top < 70 ? 1.0 : 0.0,
              child: Text(
                name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontFamily: popPinsMedium, color: Colors.black),
              )),
          background: SizedBox(
              height: size.height,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Photoview(
                              image: imageString,
                            )));
                  },
                  child: image(
                    imageString,
                  ))),
        );
      }),
      expandedHeight: 400,
    );
  }

  Future<String> getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(langKey);
  }

  String lang = "tm";

  setData() {
    setState(() {
      getData().then((value) {
        lang = value ?? "tm";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: FutureBuilder<ProductModel>(
            future: ProductModel().getProductById(widget.drugID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    backgroundColor: Colors.white,
                    bottomSheet: orderButton(
                        icon: snapshot.data.stockCount == 0 ? false : true,
                        name: snapshot.data.stockCount == 0
                            ? "notification"
                            : "addCartTitle",
                        product: snapshot.data),
                    body: hasData(size, context, snapshot.data));
              } else if (snapshot.hasError) {
                return const Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                        child: Icon(Icons.refresh,
                            color: kPrimaryColor, size: 35)));
              }

              return Scaffold(backgroundColor: Colors.white, body: spinKit());
            }));
  }
}
