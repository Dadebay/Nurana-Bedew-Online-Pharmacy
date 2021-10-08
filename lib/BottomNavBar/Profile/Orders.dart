// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:medicine_app/BottomNavBar/ProductCard.dart';
import 'package:medicine_app/Others/Models/OrdersModel.dart';
import 'package:medicine_app/Others/Models/ProductsModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar("orders"),
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
                                  return const ProductCard(cartQuantity: 1);
                                },
                              );
                            })
                      ],
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
