import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';

import '../../views/cart_view/controller/cart_view_controller.dart';

class AddCartButton extends StatefulWidget {
  const AddCartButton({
    required this.id,
    required this.productProfil,
    Key? key,
    required this.stockCount,
    required this.name,
    required this.image,
    required this.price,
  }) : super(key: key);

  final int id;
  final String image;
  final String name;
  final String price;
  final bool productProfil;
  final int stockCount;

  @override
  State<AddCartButton> createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> {
  bool addCartBool = false;
  final CartViewController cartController = Get.put(CartViewController());
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    changeCartCount2();
  }

  dynamic changeCartCount2() {
    for (final element in cartController.cartList) {
      if (element['id'] == widget.id) {
        addCartBool = true;
        quantity = element['quantity'];
      }
    }
  }

  Widget buttonPart() {
    return GestureDetector(
      onTap: () {
        if (widget.stockCount == 0) {
          notifiyMe(widget.id);
        } else {
          addCartBool = !addCartBool;
          cartController.addToCard(id: widget.id, quantity: quantity, image: widget.image, name: widget.name, price: widget.price, stockCount: widget.stockCount.toString());
          setState(() {});
        }
      },
      child: Container(
        width: Get.size.width,
        margin: widget.productProfil ? EdgeInsets.all(20) : EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: widget.productProfil ? 8 : 6),
        decoration: BoxDecoration(
          color: widget.stockCount == 0 ? Colors.red : kPrimaryColor,
          borderRadius: widget.productProfil ? borderRadius10 : borderRadius5,
        ),
        child: widget.productProfil
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 2, right: 8),
                    child: Icon(
                      IconlyBroken.bag,
                      color: widget.stockCount == 0 ? Colors.red : Colors.white,
                    ),
                  ),
                  Text(
                    widget.stockCount == 0 ? "notification".tr : "addCartTitle".tr,
                    style: TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18),
                  ),
                ],
              )
            : Text(widget.stockCount == 0 ? "notification".tr : "addCartTitle".tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 16)),
      ),
    );
  }

  Container numberPart() {
    return Container(
      margin: widget.productProfil ? const EdgeInsets.all(15) : EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: widget.productProfil ? borderRadius10 : BorderRadius.circular(0),
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                quantity--;
                if (quantity == 0) {
                  quantity = 1;
                  addCartBool = false;
                }
                cartController.minusCardElement(widget.id);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: borderRadius10,
                ),
                child: Icon(CupertinoIcons.minus, color: Colors.white, size: widget.productProfil ? 30 : 20),
              ),
            ),
          ),
          Expanded(
            flex: widget.productProfil ? 5 : 4,
            child: GestureDetector(
              onTap: () {
                selectCount();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(color: widget.productProfil ? Colors.white : kPrimaryColor.withOpacity(0.1), borderRadius: borderRadius5),
                child: Text(
                  '$quantity',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.productProfil ? kPrimaryColor : Colors.black,
                    fontFamily: montserratBold,
                    fontSize: widget.productProfil ? 28 : 20,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                quantity++;

                cartController.updateCartQuantity(widget.id);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: borderRadius10,
                ),
                child: Icon(CupertinoIcons.add, color: Colors.white, size: widget.productProfil ? 30 : 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      changeCartCount2();
      return addCartBool ? numberPart() : buttonPart();
    });
  }

  TextEditingController controller = TextEditingController();
  selectCount() {
    controller.clear();
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
              style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 20),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontFamily: montserratMedium, color: Colors.black),
            decoration: InputDecoration(
                isDense: true,
                hintText: "${"maximum".tr} : ${widget.stockCount}",
                hintStyle: TextStyle(color: Colors.grey[400], fontFamily: montserratMedium),
                border: OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey.shade300))),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
          width: Get.size.width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                backgroundColor: kPrimaryColor,
                elevation: 1,
                shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
              ),
              onPressed: () {
                Get.back();
                int count = int.parse(controller.text.toString());
                if (count >= widget.stockCount) {
                  showSnackBar('error', 'error2', Colors.red);
                } else {
                  cartController.updateCartQuantityDialog(widget.id, int.parse(controller.text.toString()));
                }
              },
              child: Text(
                "agree".tr,
                style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.white),
              )),
        ),
      ],
    ));
  }
}
