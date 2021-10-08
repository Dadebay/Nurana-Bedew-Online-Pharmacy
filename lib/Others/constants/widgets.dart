// ignore_for_file: deprecated_member_use, duplicate_ignore, implementation_imports, avoid_positional_boolean_parameters, non_constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'constants.dart';

CustomFooter loadMore(String name) {
  return CustomFooter(
    builder: (BuildContext context, LoadStatus mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = Text(name,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: popPinsMedium,
            )).tr();
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
        body = const Text("retry",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: popPinsMedium,
            )).tr();
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
  return Text(text,
          maxLines: 1,
          style: const TextStyle(
              color: Colors.white, fontFamily: popPinsRegular, fontSize: 16))
      .tr();
}

Widget textBlck({String text}) {
  return Text(text,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
              color: Colors.black, fontFamily: popPinsRegular, fontSize: 18))
      .tr();
}

Widget buttonProfile({String name, IconData icon, Function() onTap}) {
  return Column(
    children: [
      ListTile(
        minVerticalPadding: 0,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        onTap: onTap,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        tileColor: Colors.white,
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: borderRadius15),
          child: Icon(
            icon,
            color: kPrimaryColor,
            size: 30,
          ),
        ),
        title: Text(
          name,
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: popPinsMedium),
        ).tr(),
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

AppBar appBar(String name) {
  return AppBar(
    elevation: 0.0,
    automaticallyImplyLeading: false,
    backgroundColor: kPrimaryColor,
    centerTitle: true,
    title: Text(
      name,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontFamily: popPinsMedium),
    ).tr(),
  );
}

CachedNetworkImage image(String name) {
  return CachedNetworkImage(
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
          ));
}

AppBar appBarBackButton(BuildContext context, String name) {
  return AppBar(
    elevation: 0.0,
    centerTitle: true,
    leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(IconlyLight.arrowLeft2)),
    automaticallyImplyLeading: false,
    backgroundColor: kPrimaryColor,
    title: Text(
      name,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontFamily: popPinsMedium),
    ).tr(),
  );
}

void showMessage(String text, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  Scaffold.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      backgroundColor: Colors.green.shade500,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      duration: const Duration(milliseconds: 800),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontFamily: popPinsSemiBold),
      ).tr()));
}

Future<bool> backPressed(Size size, BuildContext context) async {
  final bool value = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      title: const Text(
        'exit_app',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, fontFamily: popPinsMedium, fontSize: 18),
      ).tr(),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                elevation: 1,
                shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius10,
                    side: BorderSide(color: kPrimaryColor, width: 2)),
                color: kPrimaryColor,
                child: const Text(
                  'yes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: popPinsSemiBold),
                ).tr(),
                onPressed: () {
                  exit(0);
                }),
            RaisedButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius10,
                    side: BorderSide(color: kPrimaryColor, width: 2)),
                color: kPrimaryColor,
                child: const Text(
                  'no',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: popPinsSemiBold),
                ).tr(),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
          ],
        ),
      ],
    ),
  );
  return value;
}
