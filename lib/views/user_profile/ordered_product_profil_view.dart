import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/cards/ordered_product_profil_card.dart';
import 'package:medicine_app/data/models/products_model.dart';
import 'package:medicine_app/data/services/products_service.dart';

import '../../constants/app_bar_static.dart';
import '../../constants/constants.dart';
import '../../constants/shimmers/products_shimmer.dart';

class OrderedProductProfilView extends StatefulWidget {
  final int index;
  final int id;

  const OrderedProductProfilView({Key? key, required this.index, required this.id}) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderedProductProfilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backArrow: true,
        name: "orderHistory".tr + " ${widget.index}",
        onTap: () {},
      ),
      body: FutureBuilder<List<OrderedProductProfilModel>>(
          future: ProductsService().getOrderedProducts(id: widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ProductShimmer().shimmer(5);
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
                style: const TextStyle(fontFamily: montserratSemiBold, color: Colors.black, fontSize: 18),
              ));
            }
            return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 4 / 5.5),
                itemBuilder: (BuildContext context, int index) {
                  return OrderedProductProfilCard(
                    model: snapshot.data![index],
                    orderedProductView: true,
                  );
                });
          }),
    );
  }
}
