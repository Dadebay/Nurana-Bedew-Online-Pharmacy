import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

List<Map<String, dynamic>> myList = [];

int pageNumber = 0;
const String serverURL = "45.93.136.141:7000";
const String serverImage = "http://45.93.136.141";
const String authServerUrl = "45.93.136.141:7000";
const String langKey = "language";
////Colors
const Color kPrimaryColor = Color(0xff144DDE);
const Color kPrimaryGrey = Color(0xff737373);
const Color kPrimaryStroke = Color(0xFFececec);

///BorderRadius
const BorderRadius borderRadius5 = BorderRadius.all(Radius.circular(5));
const BorderRadius borderRadius10 = BorderRadius.all(Radius.circular(10));
const BorderRadius borderRadius15 = BorderRadius.all(Radius.circular(15));
const BorderRadius borderRadius20 = BorderRadius.all(Radius.circular(20));
const BorderRadius borderRadius30 = BorderRadius.all(Radius.circular(30));

//Fonts
const String popPinsRegular = "Poppins_Regular";
const String popPinsBold = "Poppins_Bold";
const String popPinsSemiBold = "Poppins_SemiBold";
const String popPinsMedium = "Poppins_Medium";
// text
String hightolow = 'hightolow'.tr;
String lowtohigh = 'lowtohigh'.tr;

String errorPassword = 'errorPassword'.tr;
String removeCart = 'removeCart'.tr;
String tryagain = 'tryagain'.tr;
String search = 'search'.tr;

String errorPhoneNumber = 'errorPhoneNumber'.tr;
String loremImpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
