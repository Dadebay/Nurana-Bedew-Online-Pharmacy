// ignore_for_file: deprecated_member_use, duplicate_ignore, implementation_imports, avoid_positional_boolean_parameters, non_constant_identifier_names, always_declare_return_types, type_annotate_public_apis

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medicine_app/models/NotificationModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'constants.dart';

CustomFooter loadMore(String name) {
  return CustomFooter(
    builder: (BuildContext context, LoadStatus mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = Text(name.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: popPinsMedium,
            ));
      } else if (mode == LoadStatus.loading) {
        body = const CupertinoActivityIndicator(
          radius: 15,
        );
      } else if (mode == LoadStatus.failed) {
        body = const Text("Load Failed!Click retry!");
      } else if (mode == LoadStatus.canLoading) {
        body = const Icon(
          IconlyBroken.arrowDown,
          color: Colors.black,
          size: 35,
        );
      } else {
        body = Text("retry".tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: popPinsMedium,
            ));
      }
      return SizedBox(
        height: 55.0,
        child: Center(child: body),
      );
    },
  );
}

Widget dividerr() {
  return Container(
    color: Colors.grey[300],
    width: double.infinity,
    height: 1,
  );
}

Widget spinKit() {
  return const SpinKitChasingDots(
    size: 40,
    color: kPrimaryColor,
  );
}

Widget textWht({String text}) {
  return Text(text.tr, maxLines: 1, style: const TextStyle(color: Colors.white, fontFamily: popPinsRegular, fontSize: 16));
}

Widget textBlck({String text}) {
  return Text(text.tr, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.black, fontFamily: popPinsRegular, fontSize: 18));
}

habarEt2(int productId, BuildContext context) {
  Get.dialog(AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    backgroundColor: Colors.white,
    titlePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
    title: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'noProduct'.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontFamily: popPinsMedium),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'noProductTitle'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontFamily: popPinsRegular, fontSize: 16),
          ),
        ),
      ],
    ),
    actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: borderRadius10, side: BorderSide(color: kPrimaryColor, width: 2)),
              color: kPrimaryColor,
              child: Text(
                'yes'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: popPinsSemiBold),
              ),
              onPressed: () {
                // NotificationModel().addNotification(productId);
                showMessage("Ulgama giriň".tr, context, Colors.red);
                Get.back();
                // showMessage(
                //     "notificationSend".tr, context, Colors.green.shade500);
              }),
          RaisedButton(
              shape: const RoundedRectangleBorder(borderRadius: borderRadius10, side: BorderSide(color: kPrimaryColor, width: 2)),
              color: kPrimaryColor,
              child: Text(
                'no'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: popPinsSemiBold),
              ),
              onPressed: () {
                Get.back();
              }),
        ],
      ),
    ],
  ));
}

Widget buttonProfile({String name, IconData icon, Function() onTap}) {
  return Column(
    children: [
      ListTile(
        minVerticalPadding: 0,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        onTap: onTap,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        tileColor: Colors.white,
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius15),
          child: Icon(
            icon,
            color: kPrimaryColor,
            size: 30,
          ),
        ),
        title: Text(
          name.tr,
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: popPinsMedium),
        ),
        trailing: const Icon(
          IconlyLight.arrowRight2,
          color: Colors.black,
          size: 25,
        ),
      ),
      Divider(
        height: 1,
        thickness: 1.5,
        color: Colors.grey[300],
        indent: 80,
      )
    ],
  );
}

Widget image(String name, Size size) {
  return Container(
    height: size.height,
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius10),
    child: ClipRRect(
      borderRadius: borderRadius10,
      child: CachedNetworkImage(
          width: double.infinity,
          colorBlendMode: BlendMode.difference,
          imageUrl: name,
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
                child: SvgPicture.asset(
                  "assets/icons/logo.svg",
                  color: Colors.grey,
                ),
              )),
    ),
  );
}

void showMessage(String text, BuildContext context, Color color) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      duration: const Duration(milliseconds: 800),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontFamily: popPinsSemiBold),
      )));
}
