// ignore_for_file: file_names, implementation_imports, deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/models/OrdersModel.dart';
import 'package:medicine_app/models/ProductsModel.dart';

class HistoryOrder extends StatefulWidget {
  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(backArrow: true, name: "orders"),
        body: FutureBuilder<List<OrdersModel>>(
            future: OrdersModel().getorders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: spinKit());
              } else if (snapshot.hasError) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh, color: kPrimaryColor, size: 35)),
                );
              } else if (snapshot.data == null) {
                return Center(
                    child: Text(
                  "noHistoryOrder".tr,
                  style: const TextStyle(fontFamily: popPinsSemiBold, color: Colors.black, fontSize: 18),
                ));
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: RaisedButton(
                      shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                      color: Colors.white,
                      disabledColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.all(10),
                      onPressed: () {
                        Get.to(() => OrderPage(
                              index: index + 1,
                              id: snapshot.data[index].id,
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("${"orderHistory".tr} ${index + 1}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: Get.locale.toLanguageTag() == "ru" ? FontWeight.bold : FontWeight.normal,
                                  color: Colors.black,
                                )),
                          ),
                          Expanded(
                            child: Text(snapshot.data[index].createdAt, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontFamily: popPinsRegular)),
                          ),
                          Expanded(
                            child: Text(
                              "${snapshot.data[index].totalPrice} " + "TMT",
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontFamily: popPinsMedium, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

class OrderPage extends StatefulWidget {
  final int index;
  final int id;
  const OrderPage({Key key, this.index, this.id}) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String text = 'orderHistory'.tr;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(backArrow: true, name: "$text ${widget.index}"),
        body: FutureBuilder<List<Product>>(
            future: Product().getOrderedProducts(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: spinKit());
              } else if (snapshot.hasError) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh, color: kPrimaryColor, size: 35)),
                );
              } else if (snapshot.data == null) {
                return Center(
                    child: Text(
                  "noHistoryOrder".tr,
                  style: const TextStyle(fontFamily: popPinsSemiBold, color: Colors.black, fontSize: 18),
                ));
              }
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                        color: Colors.white,
                        disabledColor: Colors.white,
                        padding: const EdgeInsets.only(bottom: 10),
                        elevation: 2,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        focusElevation: 3,
                        hoverElevation: 3,
                        disabledElevation: 3,
                        onPressed: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: image("$serverImage/${snapshot.data[index].images}-mini.webp", size)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                snapshot.data[index].productName,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "price".tr,
                                    style: const TextStyle(color: Colors.grey, fontFamily: popPinsRegular, fontSize: 14),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(text: " ${snapshot.data[index].price}", style: const TextStyle(fontFamily: popPinsMedium, fontSize: 18, color: Colors.black)),
                                        const TextSpan(text: " TMT", style: TextStyle(fontFamily: popPinsMedium, fontSize: 12, color: Colors.black))
                                      ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
