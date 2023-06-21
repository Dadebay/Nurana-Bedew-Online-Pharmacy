import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onTap;

  const RetryButton({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: borderRadius10),
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.all(10),
            ),
            onPressed: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, color: Colors.white, size: 35),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "tryagain".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold),
                ),
              ],
            )));
  }
}
