// ignore_for_file: file_names, avoid_print, unnecessary_statements, missing_return, implementation_imports, type_annotate_public_apis, always_declare_return_types, invariant_booleans, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/controllers/CartPageController.dart';
import 'package:medicine_app/models/AuthModel.dart';
import 'package:medicine_app/views/HomePage/ProductProfil/ProductProfil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OrderPage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartPageController cartPageController = Get.put(CartPageController());

  @override
  void initState() {
    super.initState();
    cartPageController.loadData();
  }

  Widget floatingActionButton() {
    double result = 0.0;
    int count = 0;
    double price = 0.0;
    return FloatingActionButton.extended(
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      onPressed: () {
        final token = Auth().getToken();
        if (token == null) {
          showMessage("Ulgama giriň".tr, context, Colors.red);
        } else {
          price = 0;
          count = 0;
          for (final element in cartPageController.list) {
            price = double.parse(element["price"]);
            final double doubleVar = element["quantity"].toDouble();
            result += price * doubleVar;
            count += element['quantity'];
          }
          cartPageController.list.isEmpty
              ? null
              : Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderPage(
                        count: count,
                        price: result,
                      )));
        }
      },
      backgroundColor: kPrimaryColor,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "order".tr,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: popPinsSemiBold, fontSize: 18, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              IconlyLight.arrowRightCircle,
              size: 20,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(child: Obx(() {
      return Scaffold(
          appBar: const MyAppBar(name: "cart", backArrow: false),
          floatingActionButton: cartPageController.list.isEmpty ? const SizedBox.shrink() : floatingActionButton(),
          body: cartPageController.list.isEmpty
              ? myList.isEmpty
                  ? emptyCart(size)
                  : Center(
                      child: spinKit(),
                    )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cartPageController.list.length,
                  itemBuilder: (context, index) {
                    return cartCard(
                      index: index,
                    );
                  },
                ));
    }));
  }

  Padding emptyCart(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Image.asset(
                  "assets/images/noItem.png",
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("cartEmpty".tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: popPinsMedium,
                      fontSize: 24,
                    )),
              ),
            ),
          )
        ],
      ),
    );
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

  Widget cartCard({int index}) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductProfil(
                  drugID: cartPageController.list[index]["id"],
                  quantity: cartPageController.list[index]["quantity"],
                  refreshPage: 3,
                )));
      },
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, index + 1 == cartPageController.list.length ? 70 : 15),
          child: Material(
            elevation: 1,
            borderRadius: borderRadius10,
            color: Colors.white,
            child: Container(
              height: 160,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: image("$serverImage/${cartPageController.list[index]["image"]}-mini.webp", size),
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
                                  cartPageController.list[index]["name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium, fontSize: 18),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  saveData(cartPageController.list[index]["id"], 0);

                                  cartPageController.list.removeAt(index);
                                },
                                child: const Icon(
                                  IconlyLight.delete,
                                  color: kPrimaryColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(
                                  "price".tr,
                                  style: const TextStyle(color: Colors.grey, fontFamily: popPinsRegular, fontSize: 14),
                                ),
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: "${cartPageController.list[index]["price"]}",
                                      style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: popPinsMedium),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: ' TMT ',
                                          style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: popPinsMedium),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (cartPageController.list[index]["quantity"] != 0) {
                                    cartPageController.list[index]["quantity"] -= 1;
                                    myList[index]["cartQuantity"] -= 1;
                                    saveData(cartPageController.list[index]["id"], myList[index]["cartQuantity"]);
                                    if (cartPageController.list[index]["quantity"] == 0) {
                                      cartPageController.list.removeAt(index);
                                    }
                                  } else {
                                    cartPageController.list.removeAt(index);
                                    saveData(cartPageController.list[index]["id"], 0);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                                  child: const FittedBox(
                                    child: Icon(
                                      Icons.remove,
                                      color: kPrimaryColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  controller.clear();
                                  selectCount(cartPageController.list[index]["id"], cartPageController.list[index]["stockMin"], index);
                                },
                                color: Colors.grey[200],
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                                child: Text(
                                  "${cartPageController.list[index]["quantity"]}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: popPinsMedium),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final int a = cartPageController.list[index]['stockMin'];
                                  final int b = cartPageController.list[index]["quantity"] + 1;
                                  if (a > b) {
                                    cartPageController.list[index]["quantity"] += 1;
                                    myList[index]["cartQuantity"] += 1;
                                    saveData(cartPageController.list[index]["id"], cartPageController.list[index]["quantity"]);
                                  } else {
                                    showMessage("Haryt Ammarda Yok", context, Colors.red);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                                  child: const FittedBox(
                                    child: Icon(
                                      Icons.add,
                                      color: kPrimaryColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  int currentValue = 0;

  TextEditingController controller = TextEditingController();
  selectCount(int id, int maxValue, int index) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "maximum2".tr,
              style: const TextStyle(color: Colors.black, fontFamily: popPinsSemiBold, fontSize: 18),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontFamily: popPinsMedium, color: Colors.black),
            decoration: InputDecoration(
                isDense: true,
                hintText: "${"maximum".tr} : $maxValue",
                hintStyle: TextStyle(color: Colors.grey[400], fontFamily: popPinsMedium),
                border: OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey[300]))),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          width: Get.size.width,
          child: RaisedButton(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: kPrimaryColor,
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
              onPressed: () {
                currentValue = int.parse(controller.text);
                if (currentValue < maxValue) {
                  setState(() {
                    saveData(id, currentValue);
                    cartPageController.list[index]["quantity"] = currentValue;
                    Get.back();
                  });
                } else {
                  showMessage("error".tr, context, Colors.red);
                }
              },
              child: Text(
                "agree".tr,
                style: const TextStyle(fontFamily: popPinsMedium, fontSize: 18, color: Colors.white),
              )),
        ),
      ],
    ));
  }
}
