import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ConnectionCheckViewDialog extends StatelessWidget {
  const ConnectionCheckViewDialog({Key? key, required this.retryButtonTap}) : super(key: key);
  final VoidCallback retryButtonTap;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: borderRadius20),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              padding: const EdgeInsets.only(top: 100),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'noConnection1'.tr,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: kPrimaryColor,
                      fontFamily: montserratMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      'noConnection2'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: montserratMedium,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                    ),
                    onPressed: retryButtonTap,
                    child: Text(
                      "noConnection3".tr,
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: montserratMedium),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 70,
              minRadius: 60,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipRRect(
                  child: Image.asset(
                    "assets/icons/noconnection.gif",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
