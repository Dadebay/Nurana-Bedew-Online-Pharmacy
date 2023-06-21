// ignore_for_file: deprecated_member_use, duplicate_ignore, implementation_imports, avoid_positional_boolean_parameters, non_constant_identifier_names, always_declare_return_types, type_annotate_public_apis, missing_return, always_use_package_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:medicine_app/data/services/notification_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

import '../views/home_view/controllers/home_view_controller.dart';
import 'constants.dart';
import 'dialogs/change_lang_dialog.dart';

SnackbarController showSnackBar(String title, String subtitle, Color color) {
  if (SnackbarController.isSnackbarBeingShown) {
    SnackbarController.cancelAllSnackbars();
  }
  return Get.snackbar(
    title,
    subtitle,
    snackStyle: SnackStyle.FLOATING,
    titleText: title == ''
        ? const SizedBox.shrink()
        : Text(
            title.tr,
            style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.white),
          ),
    messageText: Text(
      subtitle.tr,
      style: const TextStyle(fontFamily: montserratRegular, fontSize: 16, color: Colors.white),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color,
    borderRadius: 20.0,
    animationDuration: const Duration(milliseconds: 500),
    margin: const EdgeInsets.all(8),
  );
}

Widget text(String text1, String text2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          text1.tr,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
        ),
      ),
      Expanded(
        child: Text(
          text2.tr,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
        ),
      ),
    ],
  );
}

Future langSelect(BuildContext context) => showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        return ChangeLangDialog(a1: a1);
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SizedBox.shrink();
      },
    );
CustomFooter footer() {
  return CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = const Text('Garaşyň...');
      } else if (mode == LoadStatus.loading) {
        body = CircularProgressIndicator(
          color: kPrimaryColor,
        );
      } else if (mode == LoadStatus.failed) {
        body = const Text('Load Failed!Click retry!');
      } else if (mode == LoadStatus.canLoading) {
        body = const Text('');
      } else {
        body = const Text('No more Data');
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
  return Center(
    child: const SpinKitChasingDots(
      size: 40,
      color: kPrimaryColor,
    ),
  );
}

Padding textWidgets({required String text1, required String text2, required double fontSize, bool tmt = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: const TextStyle(color: Colors.grey, fontFamily: montserratRegular, fontSize: 16),
        ),
        if (tmt)
          Expanded(
              child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: text2, style: const TextStyle(fontFamily: montserratMedium, fontSize: 20, color: Colors.black)),
              const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: Colors.black54))
            ]),
          ))
        else
          Expanded(
            child: Text(
              text2,
              maxLines: 3,
              style: TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: fontSize ?? 16),
            ),
          ),
      ],
    ),
  );
}

Widget selectLang() {
  return ListTile(
    tileColor: Colors.white,
    focusColor: Colors.white,
    hoverColor: Colors.white,
    selectedTileColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    onTap: () async {
      changeLanguage();
    },
    leading: CircleAvatar(
      backgroundImage: AssetImage(Get.locale!.languageCode.toString() == "tr" ? tkmIcon : ruIcon),
      radius: 18,
    ),
    title: Text(
      Get.locale!.languageCode.toString() == "tr" ? "Türkmen dili" : "Rus dili",
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
    ),
    trailing: const Icon(
      IconlyLight.arrowRightCircle,
      color: Colors.black,
      size: 20,
    ),
  );
}

dynamic notifiyMe(int productId) {
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
          style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 22),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'noProductTitle'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18),
          ),
        ),
      ],
    ),
    actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 1,
                shape: const RoundedRectangleBorder(borderRadius: borderRadius10, side: BorderSide(color: kPrimaryColor, width: 2)),
                backgroundColor: kPrimaryColor,
              ),
              child: Text(
                'yes'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold),
              ),
              onPressed: () {
                NotificationService().addNotification(productId).then((value) {
                  if (value == true) {
                    Get.back();
                    showSnackBar("notificationSend".tr, "notificationSend2".tr, Colors.green.shade500);
                  } else {
                    Get.back();
                    showSnackBar("tryagain".tr, "retry".tr, Colors.red);
                  }
                });
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: borderRadius10, side: BorderSide(color: kPrimaryColor, width: 2)),
                backgroundColor: kPrimaryColor,
              ),
              child: Text(
                'no'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold),
              ),
              onPressed: () {
                Get.back();
              }),
        ],
      ),
    ],
  ));
}

void changeLanguage() {
  final HomeViewController homePageController = Get.put(HomeViewController());
  Get.bottomSheet(Container(
    padding: const EdgeInsets.only(bottom: 20),
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "select_language".tr,
                style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark_circle, size: 22, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
              onTap: () {
                homePageController.switchLang('tr');
                Get.back();
              },
              leading: const CircleAvatar(
                backgroundImage: AssetImage(tkmIcon),
                backgroundColor: Colors.white,
                radius: 20,
              ),
              title: const Text(
                "Türkmen",
                style: TextStyle(fontFamily: montserratMedium),
              )),
        ),
        dividerr(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
              onTap: () {
                homePageController.switchLang('ru');

                Get.back();
              },
              leading: const CircleAvatar(
                backgroundImage: AssetImage(ruIcon),
                radius: 20,
                backgroundColor: Colors.white,
              ),
              title: const Text(
                "Русский",
                style: TextStyle(fontFamily: montserratMedium),
              )),
        ),
      ],
    ),
  ));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void logOut() {
  Get.bottomSheet(Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "log_out".tr,
                style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark_circle, size: 22, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text("log_out_title".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: montserratMedium,
                fontSize: 16,
              )),
        ),
        GestureDetector(
          onTap: () async {
            // await Auth().logout();
            // Auth().removeToken();
            // Auth().removeRefreshToken();
            // Get.toEnd(() => ConnectionCheck());
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius10),
            child: Text(
              "yes".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: montserratBold, fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius10),
            child: Text(
              "no".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  ));
}

Widget shareApp() {
  return ListTile(
    tileColor: Colors.white,
    focusColor: Colors.white,
    hoverColor: Colors.white,
    selectedTileColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    onTap: () {
      Share.share('https://play.google.com/store/apps/details?id=com.bilermennesil.medicalapp', subject: 'Nurana Bedew');
    },
    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius15), child: Image.asset("assets/icons/share.png", width: 25)),
    title: Text(
      "share".tr,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
    ),
    trailing: const Icon(
      IconlyLight.arrowRightCircle,
      color: Colors.black,
      size: 18,
    ),
  );
}
