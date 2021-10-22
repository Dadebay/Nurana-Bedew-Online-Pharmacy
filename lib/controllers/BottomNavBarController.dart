// ignore_for_file: always_declare_return_types, type_annotate_public_apis, unnecessary_this, file_names

import 'package:get/state_manager.dart';

class BottomNavBarController extends GetxController {
  final _selectedPageIndex = 0.obs;

  get selectedIndex => this._selectedPageIndex.value;
  set selectedIndex(index) => this._selectedPageIndex.value = index;
}
