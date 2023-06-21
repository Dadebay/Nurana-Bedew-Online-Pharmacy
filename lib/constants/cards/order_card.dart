import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../views/cart_view/controller/cart_view_controller.dart';
import '../constants.dart';
import '../widgets.dart';

class OrderCard extends StatelessWidget {
  final int index;
  final CartViewController cartPageController = Get.put(CartViewController());

  OrderCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          )),
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: borderRadius5,
            child: CachedNetworkImage(
                width: double.infinity,
                colorBlendMode: BlendMode.difference,
                imageUrl: cartPageController.cartList[index]['image'],
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
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
        minLeadingWidth: 50,
        minVerticalPadding: 20,
        trailing: Column(
          children: [
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: cartPageController.cartList[index]['price'],
                style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                children: const <TextSpan>[
                  TextSpan(
                    text: ' TMT ',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: montserratMedium),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text("${cartPageController.cartList[index]['quantity']} sany", style: const TextStyle(color: kPrimaryColor, fontSize: 18, fontFamily: montserratBold)),
            )
          ],
        ),
        title: Text(cartPageController.cartList[index]['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: montserratMedium)),
      ),
    );
    ;
  }
}
