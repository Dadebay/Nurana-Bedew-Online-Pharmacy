import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/data/models/notification_model.dart';
import 'package:medicine_app/data/services/notification_service.dart';

import '../constants.dart';
import '../widgets.dart';

class WaitingProductCard extends StatelessWidget {
  final NotificationModel product;

  const WaitingProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 3, blurRadius: 3)], borderRadius: borderRadius15),
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imagePart(),
          textPart(),
        ],
      ),
    );
  }

  Widget textPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            product.productName!,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
          ),
          Row(
            children: [
              Text(
                "price".tr,
                style: const TextStyle(color: Colors.grey, fontFamily: montserratRegular, fontSize: 14),
              ),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: " ${product.price}", style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black)),
                    const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 12, color: Colors.black))
                  ]),
                ),
              )
            ],
          ),
          SizedBox(
            width: Get.size.width,
            child: ElevatedButton(
                onPressed: () {
                  Get.back();

                  NotificationService().removeNotification(product.notificationId!).then((value) {
                    if (value == true) {
                      showSnackBar('deleted', "deletedSubtitle", Colors.green);
                    } else {
                      showSnackBar('error', 'deleteError', Colors.red);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(elevation: 1, backgroundColor: Colors.red, padding: EdgeInsets.all(0), shape: RoundedRectangleBorder(borderRadius: borderRadius10)),
                child: Text(
                  'Ayyr',
                  style: TextStyle(color: Colors.white, fontFamily: montserratSemiBold),
                )),
          ),
        ],
      ),
    );
  }

  Expanded imagePart() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius10),
        child: ClipRRect(
          borderRadius: borderRadius10,
          child: CachedNetworkImage(
              width: double.infinity,
              colorBlendMode: BlendMode.difference,
              imageUrl: "$serverURL/${product.image}-mini.webp",
              imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Center(child: spinKit()),
              errorWidget: (context, url, error) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      "assets/icons/logo.png",
                      color: Colors.grey,
                    ),
                  )),
        ),
      ),
    );
  }
}
