// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn) {
    return navigationKey.currentState.pushReplacementNamed(_rn);
  }

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState.pushNamed(_rn);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
    return navigationKey.currentState.push(_rn);
  }

  void goback() {
    return navigationKey.currentState.pop();
  }
  // ignore: eol_at_end_of_file
}
