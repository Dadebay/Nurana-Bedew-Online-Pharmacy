import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/cards/cart_card.dart';
import 'package:medicine_app/views/cart_view/controller/cart_view_controller.dart';

import '../../../constants/app_bar_static.dart';
import '../../../constants/buttons/go_to_order_view_button.dart';
import '../../../constants/empty_states/empty_cart.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartViewController cartPageController = Get.put(CartViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          name: "cart",
          backArrow: false,
          onTap: () {},
        ),
        floatingActionButton: cartPageController.cartList.isEmpty ? const SizedBox.shrink() : GoToOrderViewButton(),
        body: Obx(() {
          return Center(
            child: cartPageController.cartList.isEmpty
                ? EmptyCart()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartPageController.cartList.length,
                    itemBuilder: (context, index) {
                      return CartCard(
                        index: index,
                      );
                    },
                  ),
          );
        }));
  }
}
