import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class ProductShimmer {
  GridView shimmer(int count) {
    return GridView.builder(
        itemCount: count,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 2 : 4, childAspectRatio: 3 / 4.5),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(6),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius10),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius5),
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: Get.size.width / 4,
                        color: Colors.grey,
                        height: 20,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: Get.size.width / 3,
                        color: Colors.grey,
                        height: 20,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: Get.size.width,
                        decoration: const BoxDecoration(color: Colors.grey, borderRadius: borderRadius5),
                        height: 35,
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
