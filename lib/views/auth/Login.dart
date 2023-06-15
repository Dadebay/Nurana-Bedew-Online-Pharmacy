// ignore_for_file: avoid_redundant_argument_values, implementation_imports, file_names, noop_primitive_operations, avoid_positional_boolean_parameters, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medicine_app/components/willPopScope.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/controllers/LoginController.dart';
import 'package:medicine_app/models/AuthModel.dart';
import 'package:medicine_app/views/BottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> firsttimeSaveData(bool value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  print(pref.setBool("firstTime", value));
  await pref.setBool("firstTime", value);
  pref.setBool("firstTime", value).then((value) {
    print(value);
    print('----------------------------------------------------------------------------------------');
  });
  return pref.setBool("firstTime", value);
}

class Login extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  TextEditingController controllerLogin1 = TextEditingController();
  TextEditingController controllerLogin2 = TextEditingController();
  FocusNode focusNodeLogin1 = FocusNode();
  FocusNode focusNodeLogin2 = FocusNode();

  final GlobalKey<FormState> _form1Key = GlobalKey();

  Widget agreeButton(BuildContext context, Size size) {
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          final SharedPreferences preferences = await SharedPreferences.getInstance();
          myList.clear();
          final String encodedMap = json.encode(myList);
          preferences.setString('cart', encodedMap);

          if (_form1Key.currentState.validate() && controllerLogin1.text.length == 8) {
            loginController.changeStatus();
            Auth().loginUser(phone: controllerLogin1.text.toString(), password: controllerLogin2.text.toString()).then((value) {
              if (value == true) {
                firsttimeSaveData(true);
                Get.to(() => BottomNavBar());
              } else {
                controllerLogin1.clear();
                controllerLogin2.clear();
                loginController.changeStatus();
                _form1Key.currentState.validate();
              }
            });
          } else {
            /// Vibratioin bardy
          }
        },
        child: Center(
          child: PhysicalModel(
            elevation: 4,
            borderRadius: borderRadius15,
            color: kPrimaryColor,
            shadowColor: Colors.black,
            child: AnimatedContainer(
              decoration: const BoxDecoration(
                borderRadius: borderRadius15,
                color: kPrimaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              curve: Curves.ease,
              width: loginController.animation.value ? 70 : size.width,
              duration: const Duration(milliseconds: 1000),
              child: loginController.animation.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "agree".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontFamily: popPinsSemiBold, color: Colors.white),
                    ),
            ),
          ),
        ),
      );
    });
  }

  Column namePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              "welcome".tr,
              style: const TextStyle(color: Colors.black, fontFamily: popPinsSemiBold, fontSize: 20),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "welcomeTitle".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontFamily: popPinsRegular, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget phoneNumber() {
    return TextFormField(
      style: const TextStyle(fontFamily: popPinsMedium, fontSize: 18, color: Colors.black),
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: focusNodeLogin1,
      controller: controllerLogin1,
      validator: (value) => value.isEmpty ? errorPhoneNumber : null,
      onEditingComplete: () {
        focusNodeLogin2.requestFocus();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(8),
      ],
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontFamily: popPinsRegular),
        contentPadding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 2),
          child: Text(
            '+ 993  ',
            style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: popPinsMedium),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: '__ ______',
        labelStyle: const TextStyle(fontFamily: popPinsMedium, fontSize: 16, color: Colors.black38),
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[200], width: 2), borderRadius: borderRadius10),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 2), borderRadius: borderRadius10),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[100],
            ),
            borderRadius: borderRadius10),
      ),
    );
  }

  Widget textfieldPassword() {
    return TextFormField(
      style: const TextStyle(fontFamily: popPinsMedium, fontSize: 18, color: Colors.black),
      textInputAction: TextInputAction.next,
      controller: controllerLogin2,
      validator: (value) => value.isEmpty ? errorPassword : null,
      obscuringCharacter: "*",
      focusNode: focusNodeLogin2,
      keyboardType: TextInputType.number,
      obscureText: loginController.obscure.value,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontFamily: popPinsRegular),
        suffixIcon: GestureDetector(
          onTap: () {
            loginController.changeObscure();
          },
          child: Icon(
            loginController.obscure.value ? Icons.visibility_off : Icons.visibility,
            color: loginController.obscure.value ? Colors.grey : kPrimaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        fillColor: Colors.grey[100],
        filled: true,
        label: Text("password".tr),
        labelStyle: const TextStyle(color: Colors.black38, fontFamily: popPinsMedium),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[200], width: 2), borderRadius: borderRadius10),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[100],
            ),
            borderRadius: borderRadius10),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 2), borderRadius: borderRadius10),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[100],
            ),
            borderRadius: borderRadius10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MyWillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Image.asset('assets/images/diller/logo.png', fit: BoxFit.fill),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: namePart(),
                    ),
                    Form(
                      key: _form1Key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          phoneNumber(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: textfieldPassword(),
                          ),
                        ],
                      ),
                    ),
                    agreeButton(context, size),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
