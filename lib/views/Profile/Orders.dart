// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:medicine_app/components/ProductCard.dart';
import 'package:medicine_app/components/appBar.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/models/OrdersModel.dart';
import 'package:medicine_app/models/ProductsModel.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(name: "orders", backArrow: false),
        body: FutureBuilder<List<OrdersModel>>(
            future: OrdersModel().getorders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return spinKit();
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text("Order ${index + 1}"),
                      children: [
                        FutureBuilder<List<Product>>(
                            future: Product().getProducts(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return const ProductCard();
                                },
                              );
                            })
                      ],
                    );
                  },
                );
              }
              return spinKit();
            }),
      ),
    );
  }
}
