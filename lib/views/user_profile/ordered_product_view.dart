// ignore_for_file: file_names, implementation_imports, deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/data/services/order_service.dart';

import '../../constants/app_bar_static.dart';
import '../../constants/cards/ordered_products_card.dart';
import '../../data/models/order_model.dart';

class OrderedProductsView extends StatefulWidget {
  @override
  _OrderedProductsViewState createState() => _OrderedProductsViewState();
}

class _OrderedProductsViewState extends State<OrderedProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backArrow: true,
        name: "orders",
        onTap: () {},
      ),
      body: FutureBuilder<List<OrdersModel>>(
          future: OrderService().getorders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return spinKit();
            } else if (snapshot.hasError) {
              return Center(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh, color: kPrimaryColor, size: 35)));
            } else if (snapshot.data == null) {
              return Center(child: Text("noHistoryOrder".tr, style: const TextStyle(fontFamily: montserratSemiBold, color: Colors.black, fontSize: 18)));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return OrderedProductsCard(
                  index: index,
                  model: snapshot.data![index],
                );
              },
            );
          }),
    );
  }
}
