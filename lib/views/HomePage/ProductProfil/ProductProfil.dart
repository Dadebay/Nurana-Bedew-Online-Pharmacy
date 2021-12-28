// ignore_for_file: implementation_imports, deprecated_member_use, file_names, unnecessary_string_interpolations, avoid_bool_literals_in_conditional_expressions, type_annotate_public_apis, always_declare_return_types, unnecessary_statements, avoid_print

import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/controllers/CartPageController.dart';
import 'package:medicine_app/controllers/HomePageController.dart';
import 'package:medicine_app/controllers/NewInComeController.dart';
import 'package:medicine_app/models/ProductProfilModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../views/BottomNavBar.dart';
import 'PhotoView.dart';

class ProductProfil extends StatefulWidget {
  const ProductProfil({Key key, this.drugID, @required this.quantity, @required this.refreshPage}) : super(key: key);
  final int drugID;
  final int quantity;
  final int refreshPage;

  @override
  _ProductProfilState createState() => _ProductProfilState();
}

class _ProductProfilState extends State<ProductProfil> {
  bool orderButtonChange = false;
  int quantity = 1;
  @override
  void initState() {
    super.initState();
    quantity = widget.quantity ?? 0;
    BackButtonInterceptor.add(myInterceptor);
    orderButtonChange = widget.quantity == 0 ? false : true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  // ignore: avoid_positional_boolean_parameters
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (widget.refreshPage == 1) {
      homeController.reolodProduct();
      Get.to(() => BottomNavBar());
    } else if (widget.refreshPage == 2) {
      newInComeController.reolodProduct();
      Get.to(() => BottomNavBar());
    } else if (widget.refreshPage == 3) {
      cartPageController.loadData();
      Get.to(() => BottomNavBar());
    } else if (widget.refreshPage == 0) {
      Get.to(() => BottomNavBar());
    }
    return true;
  }

  final HomePageController homeController = Get.put(HomePageController());
  final NewInComeController newInComeController = Get.put(NewInComeController());
  final CartPageController cartPageController = Get.put(CartPageController());
  Widget hasData(Size size, BuildContext context, ProductModel product) {
    return CustomScrollView(
      slivers: [
        imagePart(size, "$serverImage/${product.images}-big.webp", "${product.productName}"),
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
              style: const TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(
                  "price".tr,
                  style: const TextStyle(color: Colors.grey, fontFamily: popPinsRegular, fontSize: 16),
                ),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(text: " ${product.price}", style: const TextStyle(fontFamily: popPinsSemiBold, fontSize: 20, color: Colors.black)),
                      const TextSpan(text: " TMT", style: TextStyle(fontFamily: popPinsSemiBold, fontSize: 16, color: Colors.black))
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
                Text(
                  "dateOfExpire".tr,
                  style: const TextStyle(color: Colors.black38, fontFamily: popPinsRegular, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    "${product.dateOfExpire.substring(0, 10)}",
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium, fontSize: 16),
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
                Text(
                  "quantity".tr,
                  style: const TextStyle(color: Colors.black38, fontFamily: popPinsRegular, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    " ${product.quantity}",
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium, fontSize: 16),
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
                Text(
                  "producer".tr,
                  style: const TextStyle(color: Colors.black38, fontFamily: popPinsRegular, fontSize: 16),
                ),
                const Text(
                  " : ",
                  style: TextStyle(color: Colors.black38, fontFamily: popPinsMedium, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    "${product.producerName}",
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          if (product.descriptionTm == "" || product.descriptionRu == "" || product.descriptionTm == null || product.descriptionRu == null)
            const SizedBox.shrink()
          else if (Get.locale.toLanguageTag() == "en")
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("descriptionTm".tr, style: const TextStyle(fontFamily: popPinsRegular, fontSize: 16, color: Colors.grey)),
                    ),
                    Text(
                      product.descriptionTm == null ? "" : "${product.descriptionTm}",
                      style: const TextStyle(color: Colors.black, fontFamily: popPinsRegular),
                    )
                  ],
                ))
          else
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("descriptionTm".tr, style: const TextStyle(fontFamily: popPinsRegular, fontSize: 16, color: Colors.grey)),
                    ),
                    Text(
                      product.descriptionTm == null ? "" : "${product.descriptionTm}",
                      style: const TextStyle(color: Colors.black, fontFamily: popPinsRegular),
                    )
                  ],
                )),
          const SizedBox(
            height: 100,
          )
        ]))
      ],
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

  removeQuantity(ProductModel product) {
    if (quantity != 0) {
      quantity -= 1;
      final int id = int.parse(product.id);

      saveData(id, quantity);
      setState(() {
        if (quantity == 0) {
          orderButtonChange = false;
        }
      });
    }
  }

  addQuantity(ProductModel product, BuildContext context) {
    setState(() {
      if (product.stockCount > (quantity + 1)) {
        quantity += 1;
        final int id = int.parse(product.id);
        saveData(id, quantity);
      } else {
        showMessage("Haryt Ammarda Yok", context, Colors.red);
      }
    });
  }

  Widget orderButton({String name, bool icon, ProductModel product}) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                      child: const FittedBox(
                        child: Icon(
                          Icons.remove,
                          color: kPrimaryColor,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      controller.clear();
                      selectCount(widget.drugID, product.stockCount);
                    },
                    color: Colors.grey[200],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                    child: Text(
                      "$quantity",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, color: Colors.black, fontFamily: popPinsMedium),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addQuantity(product, context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
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
                icon ? null : habarEt2(widget.drugID, context);
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
                    child: Icon(icon ? IconlyLight.bag : IconlyLight.infoSquare, color: Colors.white, size: 25),
                  ),
                  Text(
                    name.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, //kPrimaryColor,
                        fontFamily: popPinsMedium,
                        fontSize: 18),
                  ),
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
            if (widget.refreshPage == 1) {
              homeController.reolodProduct();
              Get.to(() => BottomNavBar());
            } else if (widget.refreshPage == 2) {
              newInComeController.reolodProduct();
              Get.to(() => BottomNavBar());
            } else if (widget.refreshPage == 3) {
              cartPageController.loadData();
              Get.to(() => BottomNavBar());
            } else if (widget.refreshPage == 0) {
              Get.to(() => BottomNavBar());
            }
          },
          child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius15),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                IconlyLight.arrowLeft2,
                color: Colors.black,
              )),
        ),
      ),
      pinned: true,
      toolbarHeight: 60,
      flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
                style: const TextStyle(fontFamily: popPinsMedium, color: Colors.black),
              )),
          background: SizedBox(
              height: size.height,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PhotoViewPage(
                              image: imageString,
                            )));
                  },
                  child: image(imageString, Get.size))),
        );
      }),
      expandedHeight: 400,
    );
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
                    bottomSheet: orderButton(icon: snapshot.data.stockCount == 0 ? false : true, name: snapshot.data.stockCount == 0 ? "notification" : "addCartTitle", product: snapshot.data),
                    body: hasData(size, context, snapshot.data));
              } else if (snapshot.hasError) {
                return const Scaffold(backgroundColor: Colors.white, body: Center(child: Icon(Icons.refresh, color: kPrimaryColor, size: 35)));
              }

              return Scaffold(backgroundColor: Colors.white, body: spinKit());
            }));
  }

  int currentValue = 0;

  TextEditingController controller = TextEditingController();
  selectCount(
    int id,
    int maxValue,
  ) {
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
                setState(() {
                  if (currentValue == 0) {
                    orderButtonChange = false;
                    quantity = currentValue;
                    saveData(id, currentValue);
                    Get.back();
                  } else {
                    if (currentValue < maxValue) {
                      saveData(id, currentValue);
                      quantity = currentValue;
                      Get.back();
                    } else {
                      showMessage("error".tr, context, Colors.red);
                    }
                  }
                });
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
