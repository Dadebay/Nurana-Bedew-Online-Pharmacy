// ignore_for_file: unnecessary_statements, file_names, implementation_imports, type_annotate_public_apis, always_declare_return_types

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_app/BottomNavBar/HomePage/ProductProfil/ProductProfil.dart';
import 'package:medicine_app/Others/Models/AuthModel.dart';
import 'package:medicine_app/Others/Models/CartModel.dart';
import 'package:medicine_app/Others/constants/NavService.dart';
import 'package:medicine_app/Others/constants/widgets.dart';

import '../../Others/constants/constants.dart';
import 'OrderPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  int cartId;
  int count = 0;
  int price = 0;

  List cartProducts = [];

  removeQuantity(int index) {
    CartModel().updateCartProduct(
        cartID: cartId,
        productId: cartProducts[index]["id"],
        parametrs: {
          "quantity": jsonEncode(cartProducts[index]["quantity"] - 1)
        }).then((value) {
      if (value == true) {
        setState(() {
          cartProducts[index]["quantity"] -= 1;

          if (cartProducts[index]["quantity"] == 0) {
            CartModel()
                .deleteCartProduct(
                    cartID: cartId, productId: cartProducts[index]["id"])
                .then((value) {
              if (value == true) {
                showMessage(removeCart, context);

                cartProducts.removeAt(index);
              }
            });
          }
        });
      } else {
        showMessage("tryagain", context);
      }
    });
  }

  addQuantity(int index) {
    final int a = cartProducts[index]["stockMin"];
    final int b = cartProducts[index]["quantity"] + 1;
    if (a > b) {
      CartModel().updateCartProduct(
          cartID: cartId,
          productId: cartProducts[index]["id"],
          parametrs: {
            "quantity": jsonEncode(cartProducts[index]["quantity"] + 1)
          }).then((value) {
        if (value == true) {
          setState(() {
            cartProducts[index]["quantity"] + 1;
          });
        } else {
          showMessage("tryagain", context);
        }
      });
    } else {
      showMessage("emptyStockMin", context);
    }
  }

  // ignore: missing_return
  Future<List<CartModel>> getCartProducts() async {
    final token = await Auth().getToken();
    final List<CartModel> products = [];
    final response = await http.get(
        Uri.http(
          serverURL,
          "/api/user/get-cart-products",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson =
          jsonDecode(response.body)["rows"][0]["cart_products"];
      cartProducts.clear();
      for (final Map product in responseJson) {
        products.add(CartModel.fromJson(product));
        cartProducts.add({
          "id": CartModel.fromJson(product).id,
          "name": CartModel.fromJson(product).productName,
          "quantity": CartModel.fromJson(product).quantity,
          "image": CartModel.fromJson(product).images,
          "price": CartModel.fromJson(product).price,
          "stockMin": CartModel.fromJson(product).stockCount
        });
      }

      cartId = int.parse(jsonDecode(response.body)["rows"][0]["cart_id"]);

      return products;
    } else if (response.statusCode == 402) {
      Auth().refreshToken().then((value) async {
        final token = await Auth().getToken();
        final response = await http.get(
            Uri.http(serverURL, "/api/user/get-cart-products"),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            });
        final responseJson =
            jsonDecode(response.body)["rows"][0]["cart_products"];
        cartProducts.clear();
        for (final Map product in responseJson) {
          products.add(CartModel.fromJson(product));
          cartProducts.add({
            "id": CartModel.fromJson(product).id,
            "name": CartModel.fromJson(product).productName,
            "quantity": CartModel.fromJson(product).quantity,
            "image": CartModel.fromJson(product).images,
            "price": CartModel.fromJson(product).price,
            "stockMin": CartModel.fromJson(product).stockCount
          });
        }

        cartId = int.parse(jsonDecode(response.body)["rows"][0]["cart_id"]);
      });

      return Future.delayed(const Duration(milliseconds: 1000), () {
        return products;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        NavigationService.instance.navigateToReplacement("login");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: appBar("cart"),
        floatingActionButton: floatingActionButton(),
        body: FutureBuilder<List<CartModel>>(
            future: getCartProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    return cartCard(
                      index: index,
                    );
                  },
                );
              } else if (snapshot.data == null) {
                return const Center(
                    child: Icon(Icons.add, color: kPrimaryColor, size: 35));
              } else if (snapshot.hasError) {
                return const Center(
                    child: Icon(Icons.refresh, color: kPrimaryColor, size: 35));
              }

              return spinKit();
            }));
  }

  Widget floatingActionButton() {
    return SizedBox(
      width: 150,
      child: FloatingActionButton(
        elevation: 1,
        isExtended: true,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius20),
        onPressed: () {
          price = 0;
          for (final element in cartProducts) {
            price += element["price"] * element["quantity"];
          }
          cartProducts.isEmpty
              ? null
              : Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderPage(
                        count: cartProducts.length,
                        price: price,
                        cartId: cartId,
                      )));
        },
        backgroundColor: kPrimaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "order",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: popPinsSemiBold,
                  fontSize: 18,
                  color: Colors.white),
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
      ),
    );
  }

  Widget cartCard({int index}) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductProfil(
                  drugID: cartProducts[index]["id"],
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
                            "$serverImage/${cartProducts[index]["image"]}-mini.webp",
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
                                  CartModel()
                                      .deleteCartProduct(
                                          cartID: cartId,
                                          productId: cartProducts[index]["id"])
                                      .then((value) {
                                    if (value == true) {
                                      setState(() {});
                                      showMessage("removeCart", context);
                                    }
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
                                  removeQuantity(index);
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
                                  "${cartProducts[index]["quantity"]}",
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
                                  addQuantity(index);
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
