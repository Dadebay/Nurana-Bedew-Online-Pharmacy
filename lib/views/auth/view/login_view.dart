// ignore_for_file: file_names, always_use_package_imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/buttons/agree_button_view.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/textFields/custom_text_field.dart';
import 'package:medicine_app/constants/textFields/phone_number.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/data/services/sign_in_service.dart';
import 'package:medicine_app/views/home_view/controllers/home_view_controller.dart';

import '../../bottom_nav_bar.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final _form1Key = GlobalKey<FormState>();

  Column namePart() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              "welcome".tr,
              style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 24),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "welcomeTitle".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontFamily: montserratRegular, fontSize: 20),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.size.width > 800 ? 50 : 80, bottom: 20, right: 40, left: 40),
                child: Image.asset('assets/icons/logo.png', fit: BoxFit.fill),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: namePart(),
              ),
              Form(
                key: _form1Key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PhoneNumber(
                      controller: phoneNumberController,
                      mineFocus: phoneNumberFocusNode,
                      requestFocus: passwordFocusNode,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomTextField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        labelName: 'password',
                        requestfocusNode: phoneNumberFocusNode,
                      ),
                    ),
                  ],
                ),
              ),
              AgreeButton(onTap: () {
                if (_form1Key.currentState!.validate()) {
                  Get.find<HomeViewController>().agreeButton.value = !Get.find<HomeViewController>().agreeButton.value;

                  SignINService().loginUser(phone: phoneNumberController.text, password: passwordController.text).then((value) {
                    if (value == true) {
                      Get.to(() => BottomNavBar());
                    } else {
                      showSnackBar("error", "errorSubtitle", Colors.red);
                    }
                    Get.find<HomeViewController>().agreeButton.value = !Get.find<HomeViewController>().agreeButton.value;
                  });
                } else {
                  showSnackBar("error", "errorSubtitle", Colors.red);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
