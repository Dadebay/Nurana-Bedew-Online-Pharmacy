// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medicine_app/constants/constants.dart';

class MyWillPopScope extends StatelessWidget {
  final Widget child;

  const MyWillPopScope({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return backPressed(size, context);
      },
      child: child,
    );
  }

  Future<bool> backPressed(Size size, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
        title: Text(
          'exit_app'.tr,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.black, fontFamily: popPinsMedium),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: borderRadius10,
                      side: BorderSide(color: kPrimaryColor, width: 2)),
                  color: Colors.white,
                  child: Text(
                    'yes'.tr,
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontFamily: popPinsSemiBold),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  }),
              RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: borderRadius10,
                      side: BorderSide(color: kPrimaryColor, width: 2)),
                  color: Colors.white,
                  child: Text(
                    'no'.tr,
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontFamily: popPinsSemiBold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
