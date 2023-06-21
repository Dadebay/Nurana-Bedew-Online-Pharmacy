import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/buttons/add_cart_button.dart';

import '../../views/cart_view/controller/cart_view_controller.dart';
import '../../views/product_profil/product_profil_view.dart';
import '../constants.dart';
import '../widgets.dart';

class CartCard extends StatelessWidget {
  CartCard({Key? key, required this.index}) : super(key: key);
  final int index;
  final CartViewController cartPageController = Get.put(CartViewController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductProfil(
              id: cartPageController.cartList[index]['id'],
              stockCount: int.parse(cartPageController.cartList[index]['stockCount'].toString()),
              name: cartPageController.cartList[index]['name'],
              imaqe: cartPageController.cartList[index]['image'],
              price: cartPageController.cartList[index]['price'],
            ));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius15,
          boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 3, blurRadius: 3)],
        ),
        child: Row(
          children: [
            imagePart(),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    firstText(),
                    priceText(),
                    AddCartButton(
                      id: cartPageController.cartList[index]['id'],
                      productProfil: false,
                      stockCount: int.parse(cartPageController.cartList[index]['stockCount'].toString()),
                      image: cartPageController.cartList[index]['image'],
                      name: cartPageController.cartList[index]['name'],
                      price: cartPageController.cartList[index]['price'],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox priceText() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "price".tr,
            style: const TextStyle(color: Colors.grey, fontFamily: montserratRegular, fontSize: 14),
          ),
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "${cartPageController.cartList[index]["price"]}",
                style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                children: const <TextSpan>[
                  TextSpan(
                    text: ' TMT ',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: montserratMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row firstText() {
    return Row(
      children: [
        Expanded(
          child: Text(
            cartPageController.cartList[index]["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18),
          ),
        ),
        GestureDetector(
          onTap: () {
            cartPageController.deleteItemFromCart(cartPageController.cartList[index]['id']);
          },
          child: const Icon(
            IconlyLight.delete,
            color: kPrimaryColor,
          ),
        )
      ],
    );
  }

  Expanded imagePart() {
    return Expanded(
      flex: Get.size.width <= 800 ? 2 : 1,
      child: Container(
        height: Get.size.height,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius10),
        child: ClipRRect(
          borderRadius: borderRadius10,
          child: CachedNetworkImage(
              width: double.infinity,
              colorBlendMode: BlendMode.difference,
              imageUrl: cartPageController.cartList[index]["image"],
              imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder: (context, url) => spinKit(),
              errorWidget: (context, url, error) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      "assets/icons/logo.png",
                      color: Colors.grey,
                    ),
                  )),
        ),
      ),
    );
  }
}
