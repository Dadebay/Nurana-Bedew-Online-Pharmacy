// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types

import 'package:get/state_manager.dart';

class LoginController extends GetxController {
  RxBool animation = false.obs;
  RxBool obscure = false.obs;
  changeStatus() {
    if (animation.isTrue) {
      animation.toggle();
    } else {
      animation.value = true;
    }
  }

  changeObscure() {
    if (obscure.isTrue) {
      obscure.toggle();
    } else {
      obscure.value = true;
    }
  }
}
