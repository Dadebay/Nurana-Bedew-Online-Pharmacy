// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode requestfocusNode;

  CustomTextField({
    required this.labelName,
    required this.controller,
    required this.focusNode,
    required this.requestfocusNode,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
        cursorColor: Colors.black,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'errorEmpty'.tr;
          }
          return null;
        },
        onEditingComplete: () {
          requestfocusNode.requestFocus();
        },
        keyboardType: TextInputType.number,
        maxLines: 1,
        focusNode: focusNode,
        decoration: InputDecoration(
          errorMaxLines: 2,
          errorStyle: const TextStyle(fontFamily: montserratMedium),
          hintMaxLines: 5,
          helperMaxLines: 5,
          label: Text(
            labelName.tr,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade400, fontFamily: montserratMedium),
          ),
          contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20, right: 10),
          border: OutlineInputBorder(borderRadius: borderRadius20, borderSide: const BorderSide(color: Colors.grey, width: 2)),
          enabledBorder: OutlineInputBorder(borderRadius: borderRadius20, borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
          focusedBorder: OutlineInputBorder(borderRadius: borderRadius20, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius20, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: borderRadius20, borderSide: const BorderSide(color: Colors.red, width: 2)),
        ),
      ),
    );
  }
}
