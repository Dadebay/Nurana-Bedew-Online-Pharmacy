// ignore_for_file: file_names, implementation_imports, deprecated_member_use, duplicate_ignore

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/Others/Models/OrdersModel.dart';
import 'package:medicine_app/Others/Models/ProductsModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';

class HistoryOrder extends StatefulWidget {
  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBackButton(context, "orders"),
        body: FutureBuilder<List<OrdersModel>>(
            future: OrdersModel().getorders(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: RaisedButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius: borderRadius5),
                        color: Colors.white,
                        disabledColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (_) => OrderPage(
                                    index: index + 1,
                                    id: snapshot.data[index].id,
                                  )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Sargyt ${index + 1}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: popPinsMedium)),
                            ),
                            Expanded(
                              child: Text(snapshot.data[index].createdAt,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: popPinsRegular)),
                            ),
                            Expanded(
                              child: Text(
                                "${snapshot.data[index].totalPrice} " + "TMT",
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontFamily: popPinsMedium,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh,
                          color: kPrimaryColor, size: 35)),
                );
              }
              return spinKit();
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
  String text = tr('orderHistory');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: appBarBackButton(context, "$text ${widget.index}"),
        body: FutureBuilder<List<Product>>(
            future: Product().getOrderedProducts(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width <= 800 ? 2 : 4,
                        childAspectRatio: 3 / 4.5),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius: borderRadius10),
                          color: Colors.white,
                          disabledColor: Colors.white,
                          padding: const EdgeInsets.only(bottom: 10),
                          elevation: 2,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          focusElevation: 3,
                          hoverElevation: 3,
                          disabledElevation: 3,
                          onPressed: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: image(
                                      "$serverImage/${snapshot.data[index].images}-mini.webp",
                                      size)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  snapshot.data[index].productName,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: popPinsMedium),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    const Text(
                                      "price",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: popPinsRegular,
                                          fontSize: 14),
                                    ).tr(),
                                    Expanded(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  " ${snapshot.data[index].price}",
                                              style: const TextStyle(
                                                  fontFamily: popPinsMedium,
                                                  fontSize: 18,
                                                  color: Colors.black)),
                                          const TextSpan(
                                              text: " TMT",
                                              style: TextStyle(
                                                  fontFamily: popPinsMedium,
                                                  fontSize: 12,
                                                  color: Colors.black))
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
              } else if (snapshot.hasError) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh,
                          color: kPrimaryColor, size: 35)),
                );
              }
              return spinKit();
            }),
      ),
    );
  }
}
