// ignore_for_file: implementation_imports, file_names, always_declare_return_types, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/Others/Models/CartModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BottomNavBar.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key key,
    this.count,
    this.price,
  }) : super(key: key);

  final int count;
  final double price;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<String> getUsername() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('name');
  }

  void setData() {
    getUsername().then((value) {
      setState(() {
        username = value;
      });
    });
  }

  bool buttonColor = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarBackButton(context, "order"),
        body: Column(
          children: [
            Expanded(
                child: FutureBuilder<List<CartModel>>(
                    future: CartModel().getCartProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return card(snapshot.data[index], size, context);
                          },
                        );
                      } else if (snapshot.data == null) {
                        return Center(child: spinKit());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Icon(Icons.refresh,
                                color: kPrimaryColor, size: 35));
                      }

                      return spinKit();
                    })),
            bottomPart(context, size),
          ],
        ),
      ),
    );
  }

  Container bottomPart(BuildContext context, Size size) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          dividerr(),
          text("buyer", username),
          text("drugCount", "${widget.count}"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  "totalPrice",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: popPinsMedium,
                      fontSize: 16),
                ).tr(),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: "${widget.price}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: popPinsMedium),
                      children: const <TextSpan>[
                        TextSpan(
                          text: ' TMT ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: popPinsMedium),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          paymentMethod(size),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: agreeButton(context, size)),
        ],
      ),
    );
  }

  int nagt = 1;
  Padding paymentMethod(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              "paymentMethod",
              style: TextStyle(
                  color: Colors.black, fontFamily: popPinsMedium, fontSize: 16),
            ).tr(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      buttonColor = false;
                      nagt = 1;
                    });
                  },
                  elevation: 0,
                  disabledElevation: 0,
                  color: buttonColor ? Colors.white : kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: borderRadius5,
                      side: BorderSide(
                          color: buttonColor ? Colors.grey[400] : kPrimaryColor,
                          width: 2)),
                  child: Text("Nagt",
                      style: TextStyle(
                          color: buttonColor ? Colors.black : Colors.white,
                          fontFamily: popPinsMedium))),
              const SizedBox(
                width: 10,
              ),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      buttonColor = true;
                      nagt = 2;
                    });
                  },
                  elevation: 0,
                  disabledElevation: 0,
                  color: buttonColor ? kPrimaryColor : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: borderRadius5,
                      side: BorderSide(
                          color: buttonColor ? kPrimaryColor : Colors.grey[400],
                          width: 2)),
                  child: Text("Hasapdan",
                      style: TextStyle(
                          color: buttonColor ? Colors.white : Colors.black,
                          fontFamily: popPinsMedium))),
            ],
          ),
        ],
      ),
    );
  }

  Container card(CartModel cart, Size size, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]),
          )),
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: borderRadius5,
            child: CachedNetworkImage(
                width: double.infinity,
                colorBlendMode: BlendMode.difference,
                imageUrl: "$serverImage/${cart.images}-mini.webp",
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                placeholder: (context, url) => Center(child: spinKit()),
                errorWidget: (context, url, error) => Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SvgPicture.asset(
                        "assets/icons/logo.svg",
                        color: Colors.grey,
                      ),
                    )),
          ),
        ),
        minLeadingWidth: 50,
        minVerticalPadding: 20,
        trailing: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: cart.price,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: popPinsMedium),
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
        title: Text(cart.productName,
            style: const TextStyle(fontFamily: popPinsMedium)),
      ),
    );
  }

  GestureDetector agreeButton(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        CartModel().order(nagt).then((value) async {
          if (value == true) {
            final SharedPreferences preferences =
                await SharedPreferences.getInstance();
            myList.clear();
            final String encodedMap = json.encode(myList);
            preferences.setString('cart', encodedMap);
            showMessage("orderCompleted", context, Colors.green.shade500);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const BottomNavBar()));
          } else {
            showMessage("tryagain", context, Colors.red);
          }
        });
      },
      child: Center(
        child: PhysicalModel(
          elevation: 4,
          borderRadius: borderRadius15,
          color: kPrimaryColor,
          child: AnimatedContainer(
            decoration: const BoxDecoration(
              borderRadius: borderRadius15,
              color: kPrimaryColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            curve: Curves.ease,
            width: size.width,
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              "agree",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: popPinsSemiBold,
                  color: Colors.white),
            ).tr(),
          ),
        ),
      ),
    );
  }

  Padding text(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text1,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Colors.black, fontFamily: popPinsMedium, fontSize: 16),
            ).tr(),
          ),
          Expanded(
            child: Text(
              text2,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.black, fontFamily: popPinsMedium, fontSize: 16),
            ).tr(),
          ),
        ],
      ),
    );
  }
}
