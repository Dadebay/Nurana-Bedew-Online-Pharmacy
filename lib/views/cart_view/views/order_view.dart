// ignore_for_file: implementation_imports, file_names, always_declare_return_types, use_build_context_synchronously, deprecated_member_use, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/buttons/agree_button_view.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/data/services/cart_service.dart';

import '../../../constants/app_bar_static.dart';
import '../../../constants/cards/order_card.dart';
import '../../bottom_nav_bar.dart';
import '../../home_view/controllers/home_view_controller.dart';
import '../controller/cart_view_controller.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  bool buttonColor = false;
  final CartViewController cartPageController = Get.put(CartViewController());
  double totalPrice = 0.0;
  @override
  void initState() {
    super.initState();
    findTotalPriice();
    homePageController.agreeButton.value = false;
  }

  findTotalPriice() {
    cartPageController.cartList.forEach((element) {
      totalPrice += double.parse(element['price'].toString()) * int.parse(element['quantity'].toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        backArrow: true,
        name: "order",
        onTap: () {},
      ),
      body: Column(
        children: [
          Expanded(child: Obx(() {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cartPageController.cartList.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  index: index,
                );
              },
            );
          })),
          dividerr(),
          bottomPart(),
        ],
      ),
    );
  }

  final HomeViewController homePageController = Get.put(HomeViewController());

  Container bottomPart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: text("drugCount", "${cartPageController.cartList.length}"),
          ),
          Row(
            children: [
              Text(
                "totalPrice".tr,
                style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
              ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "${totalPrice}",
                    style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
                    children: const <TextSpan>[
                      TextSpan(
                        text: ' TMT ',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: montserratMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          paymentMethod(),
          AgreeButton(onTap: () {
            List newList = [];
            cartPageController.cartList.forEach((element) {
              newList.add({'id': element['id'], 'cartQuantity': element['quantity']});
            });
            homePageController.agreeButton.value = !homePageController.agreeButton.value;

            CartService().createOrder(nagt, newList).then((value) async {
              if (value == true) {
                showSnackBar("orderCompleted".tr, "orderCompletedTitle".tr, Colors.green);
                cartPageController.cartList.clear();

                Get.to(() => BottomNavBar());
                homePageController.agreeButton.value = !homePageController.agreeButton.value;
              } else {
                showSnackBar("tryagain".tr, "retry".tr, Colors.red);
                homePageController.agreeButton.value = !homePageController.agreeButton.value;
              }
            });
          }),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  int nagt = 1;
  Widget paymentMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "paymentMethod".tr,
            style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      buttonColor = false;
                      nagt = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: buttonColor ? Colors.white : kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: buttonColor ? Colors.grey.shade400 : kPrimaryColor, width: 2)),
                  ),
                  child: Text("noCreditCard".tr, overflow: TextOverflow.ellipsis, style: TextStyle(color: buttonColor ? Colors.black : Colors.white, fontFamily: montserratMedium))),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      buttonColor = true;
                      nagt = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: buttonColor ? kPrimaryColor : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: buttonColor ? kPrimaryColor : Colors.grey.shade400, width: 2)),
                  ),
                  child: Text("CreditCard".tr, overflow: TextOverflow.ellipsis, style: TextStyle(color: buttonColor ? Colors.white : Colors.black, fontFamily: montserratMedium))),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector agreeButton() {
    return GestureDetector(
        onTap: () {
          // setState(() {
          //   isPressed = true;
          // });
          // if (isPressed == true) {

          // } else {
          //   setState(() {
          //     isPressed = false;
          //   });
          // }
        },
        child: Center()
        // Center(
        //   child: PhysicalModel(
        //     elevation: 4,
        //     borderRadius: borderRadius15,
        //     color: kPrimaryColor,
        //     child: AnimatedContainer(
        //       decoration: const BoxDecoration(
        //         borderRadius: borderRadius15,
        //         color: kPrimaryColor,
        //       ),
        //       padding: const EdgeInsets.symmetric(
        //         vertical: 10,
        //       ),
        //       curve: Curves.ease,
        //       width: isPressed ? 70 : Get.size.width,
        //       duration: const Duration(milliseconds: 1000),
        //       child: isPressed
        //           ? const Center(
        //               child: CircularProgressIndicator(
        //                 color: Colors.white,
        //               ),
        //             )
        //           : Text(
        //               "agree".tr,
        //               overflow: TextOverflow.ellipsis,
        //               textAlign: TextAlign.center,
        //               style: const TextStyle(fontSize: 20, fontFamily: montserratSemiBold, color: Colors.white),
        //             ),
        //     ),
        //   ),
        // ),
        );
  }
}
