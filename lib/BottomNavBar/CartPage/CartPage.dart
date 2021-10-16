// ignore_for_file: file_names, avoid_print, unnecessary_statements, missing_return, implementation_imports, type_annotate_public_apis, always_declare_return_types, invariant_booleans, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/BottomNavBar/HomePage/ProductProfil/ProductProfil.dart';
import 'package:medicine_app/Others/Models/AuthModel.dart';
import 'package:medicine_app/Others/Models/CartModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OrderPage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartProducts = [];
  @override
  void initState() {
    super.initState();
    loadData();
    if (myList.isEmpty) {
      loading = true;
    } else {
      loading = false;
    }
  }

  bool loading = false;
  Future<List<CartModel>> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMap = prefs.getString('cart');
    final List decodedMap = json.decode(encodedMap);
    final body = json.encode(decodedMap);

    final token = await Auth().getToken();

    final response =
        await http.post(Uri.http(serverURL, "/api/user/get-cart-products"),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{"qty": body}));
    loading = true;
    if (response.statusCode == 200 &&
        (jsonDecode(response.body)["rows"]) != null) {
      final responseJson = jsonDecode(response.body)["rows"]["products"];

      if (mounted) {
        setState(() {
          cartProducts.clear();
          for (final Map product in responseJson) {
            cartProducts.add({
              "id": CartModel.fromJson(product).id,
              "name": CartModel.fromJson(product).productName,
              "quantity": 0,
              "image": CartModel.fromJson(product).images,
              "price": CartModel.fromJson(product).price,
              "stockMin": CartModel.fromJson(product).stockCount
            });
          }
          for (int i = 0; i < cartProducts.length; i++) {
            for (int j = 0; j < myList.length; j++) {
              if (cartProducts[i]["id"] == myList[j]["id"]) {
                cartProducts[i]["quantity"] = myList[j]["cartQuantity"];
              }
            }
          }
        });
      }
      return null;
    } else {
      return null;
    }
  }

  Widget floatingActionButton() {
    double result = 0.0;
    int count = 0;
    double price = 0.0;
    return FloatingActionButton.extended(
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      onPressed: () {
        price = 0;
        count = 0;
        for (final element in cartProducts) {
          price = double.parse(element["price"]);
          final double doubleVar = element["quantity"].toDouble();
          result += price * doubleVar;
          count += element['quantity'];
        }
        cartProducts.isEmpty
            ? null
            : Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => OrderPage(
                      count: count,
                      price: result,
                    )));
      },
      backgroundColor: kPrimaryColor,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "order",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: popPinsSemiBold, fontSize: 18, color: Colors.white),
          ).tr(),
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
    return SafeArea(
        child: Scaffold(
            appBar: appBar("cart"),
            floatingActionButton: cartProducts.isEmpty
                ? const SizedBox.shrink()
                : floatingActionButton(),
            body: loading
                ? cartProducts.isEmpty
                    ? emptyCart(size)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartProducts.length,
                        itemBuilder: (context, index) {
                          return cartCard(
                            index: index,
                          );
                        },
                      )
                : Center(
                    child: spinKit(),
                  )));
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                child: const Text("cartEmpty",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: popPinsMedium,
                      fontSize: 24,
                    )).tr(),
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
          if (mounted) {
            setState(() {
              element["cartQuantity"] = quantity;
            });
          }
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
                  drugID: cartProducts[index]["id"],
                  quantity: cartProducts[index]["quantity"],
                )));
      },
      child: Padding(
          padding: EdgeInsets.fromLTRB(
              15, 10, 15, index + 1 == cartProducts.length ? 70 : 15),
          child: Material(
            elevation: 1,
            borderRadius: borderRadius10,
            color: Colors.white,
            child: Container(
              height: 160,
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: borderRadius10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: image(
                        "$serverImage/${cartProducts[index]["image"]}-mini.webp",
                        size),
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
                                  cartProducts[index]["name"],
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
                                  setState(() {
                                    saveData(cartProducts[index]["id"], 0);

                                    cartProducts.removeAt(index);
                                  });
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
                                const Text(
                                  "price",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: popPinsRegular,
                                      fontSize: 14),
                                ).tr(),
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: "${cartProducts[index]["price"]}",
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
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (cartProducts[index]["quantity"] != 0) {
                                      cartProducts[index]["quantity"] -= 1;
                                      myList[index]["cartQuantity"] -= 1;
                                      saveData(cartProducts[index]["id"],
                                          myList[index]["cartQuantity"]);
                                      if (cartProducts[index]["quantity"] ==
                                          0) {
                                        cartProducts.removeAt(index);
                                      }
                                    } else {
                                      cartProducts.removeAt(index);
                                      saveData(cartProducts[index]["id"], 0);
                                    }
                                  });
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
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  currentValue = 0;
                                  selectCount2(
                                      cartProducts[index]["id"],
                                      cartProducts[index]["stockMin"],
                                      size,
                                      index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    "${cartProducts[index]["quantity"]}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: popPinsMedium),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final int a = cartProducts[index]['stockMin'];
                                  final int b =
                                      cartProducts[index]["quantity"] + 1;
                                  if (a > b) {
                                    setState(() {
                                      cartProducts[index]["quantity"] += 1;
                                      myList[index]["cartQuantity"] += 1;
                                      saveData(cartProducts[index]["id"],
                                          cartProducts[index]["quantity"]);
                                    });
                                  } else {
                                    showMessage("Haryt Ammarda Yok", context,
                                        Colors.red);
                                  }
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
  String countProcut = tr('selectCount');
  selectCount2(int id, int maxValue, Size size, int index) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: borderRadius10),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: countProcut,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: popPinsMedium),
                        children: <TextSpan>[
                          TextSpan(
                            text: " $currentValue",
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 24,
                                fontFamily: popPinsMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  NumberPicker(
                    infiniteLoop: true,
                    axis: Axis.horizontal,
                    value: currentValue,
                    minValue: 0,
                    itemHeight: 80,
                    step: maxValue >= 5 ? 5 : 1,
                    selectedTextStyle: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 24,
                        fontFamily: popPinsSemiBold),
                    maxValue: maxValue,
                    onChanged: (value) => setState(() {
                      currentValue = value;
                    }),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    width: size.width,
                    child: RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        color: kPrimaryColor,
                        elevation: 1,
                        shape: const RoundedRectangleBorder(
                            borderRadius: borderRadius5),
                        onPressed: () {
                          setState(() {
                            saveData(id, currentValue);
                            cartProducts[index]["quantity"] = currentValue;
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text(
                          "agree",
                          style: TextStyle(
                              fontFamily: popPinsMedium,
                              fontSize: 18,
                              color: Colors.white),
                        ).tr()),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
