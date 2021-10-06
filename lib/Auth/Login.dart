// ignore_for_file: avoid_redundant_argument_values, implementation_imports, file_names, noop_primitive_operations

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine_app/BottomNavBar/BottomNavBar.dart';
import 'package:medicine_app/Others/Models/AuthModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:vibration/vibration.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool animation = false;
  TextEditingController controllerLogin1 = TextEditingController();
  TextEditingController controllerLogin2 = TextEditingController();
  FocusNode focusNodeLogin1 = FocusNode();
  FocusNode focusNodeLogin2 = FocusNode();
  bool loginObscure = true;

  final GlobalKey<FormState> _form1Key = GlobalKey();

  GestureDetector agreeButton(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        if (_form1Key.currentState.validate() &&
            controllerLogin1.text.length == 12) {
          setState(() {
            animation = true;
            Auth()
                .loginUser(
                    phone: controllerLogin1.text.substring(4, 12).toString(),
                    password: controllerLogin2.text.toString())
                .then((value) {
              if (value == false) {
                controllerLogin1.clear();
                controllerLogin2.clear();
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => BottomNavBar()));
              }
            });
          });
        } else {
          animation = false;
          Vibration.vibrate();
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
            width: animation ? 70 : size.width,
            duration: const Duration(milliseconds: 1000),
            child: animation
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "agree",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: popPinsSemiBold,
                        color: Colors.white),
                  ).tr(),
          ),
        ),
      ),
    );
  }

  Column namePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: const Text(
            "welcome",
            style: TextStyle(
                color: Colors.black, fontFamily: popPinsSemiBold, fontSize: 20),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: const Text(
            "welcomeTitle",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontFamily: popPinsRegular,
                fontSize: 15),
          ).tr(),
        ),
      ],
    );
  }

  Widget phoneNumber() {
    return TextFormField(
      style: const TextStyle(
          fontFamily: popPinsMedium, fontSize: 18, color: Colors.black),
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
        LengthLimitingTextInputFormatter(13),
      ],
      onTap: () {
        setState(() {
          if (controllerLogin1.text.isEmpty) controllerLogin1.text += "+993";
        });
      },
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontFamily: popPinsRegular),
        contentPadding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        label: const Text("phoneNumber").tr(),
        labelStyle: const TextStyle(
            fontFamily: popPinsMedium, fontSize: 16, color: Colors.black38),
        fillColor: Colors.grey[100],
        filled: true,
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[200], width: 2),
            borderRadius: borderRadius10),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[200], width: 2),
            borderRadius: borderRadius10),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[200], width: 2),
            borderRadius: borderRadius10),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor, width: 2),
            borderRadius: borderRadius10),
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
      style: const TextStyle(
          fontFamily: popPinsMedium, fontSize: 18, color: Colors.black),
      textInputAction: TextInputAction.next,
      controller: controllerLogin2,
      validator: (value) => value.isEmpty ? errorPassword : null,
      obscuringCharacter: "*",
      focusNode: focusNodeLogin2,
      obscureText: loginObscure,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontFamily: popPinsRegular),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              loginObscure = !loginObscure;
            });
          },
          child: Icon(
            loginObscure ? Icons.visibility_off : Icons.visibility,
            color: loginObscure ? Colors.grey : kPrimaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        fillColor: Colors.grey[100],
        filled: true,
        label: const Text("password").tr(),
        labelStyle:
            const TextStyle(color: Colors.black38, fontFamily: popPinsMedium),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[200], width: 2),
            borderRadius: borderRadius10),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[100],
            ),
            borderRadius: borderRadius10),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor, width: 2),
            borderRadius: borderRadius10),
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
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            controllerLogin1.clear();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset('assets/images/diller/logo.png',
                        fit: BoxFit.fill),
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
    );
  }
}
