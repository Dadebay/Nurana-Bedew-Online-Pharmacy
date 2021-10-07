// ignore_for_file: implementation_imports, file_names

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/Others/Models/CartModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BottomNavBar.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key, this.count, this.price, this.cartId})
      : super(key: key);

  final int cartId;
  final int count;
  final int price;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int drugCount = 0;
  int drugPrice = 0;
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
        drugCount = widget.count;
        drugPrice = widget.price;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
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
                        return const Center(
                            child: Icon(Icons.add,
                                color: kPrimaryColor, size: 35));
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Icon(Icons.refresh,
                                color: kPrimaryColor, size: 35));
                      }

                      return spinKit();
                    })),
            dividerr(),
            text("buyer", username),
            text("drugCount", "$drugCount"),
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
                        text: "$drugPrice",
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
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: agreeButton(context, size)),
          ],
        ),
      ),
    );
  }

  Column card(CartModel cart, Size size, BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: borderRadius5,
              child: image(
                "$serverImage/${cart.images}-mini.webp",
              ),
            ),
          ),
          minLeadingWidth: 50,
          minVerticalPadding: 20,
          trailing: GestureDetector(
            onTap: () {
              CartModel()
                  .deleteCartProduct(cartID: widget.cartId, productId: cart.id)
                  .then((value) {
                if (value == true) {
                  drugCount -= 1;
                  drugPrice -= cart.price;
                  setState(() {});
                  showMessage("removeCart", context);
                }
              });
            },
            child: const Icon(IconlyLight.delete, color: kPrimaryColor),
          ),
          title: Text(cart.productName,
              style: const TextStyle(fontFamily: popPinsMedium)),
        ),
        dividerr(),
      ],
    );
  }

  GestureDetector agreeButton(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        CartModel().order().then((value) {
          if (value == true) {
            showMessage("orderCompleted", context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => BottomNavBar()));
          } else {
            showMessage("tryagain", context);
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
