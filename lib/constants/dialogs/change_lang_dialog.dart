import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../views/auth/view/login_view.dart';
import '../../views/bottom_nav_bar.dart';
import '../../views/home_view/controllers/home_view_controller.dart';
import '../constants.dart';

class ChangeLangDialog extends StatelessWidget {
  final HomeViewController homePageController = Get.put(HomeViewController());

  ChangeLangDialog({Key? key, required this.a1}) : super(key: key);
  final Animation<double> a1;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: a1.value,
      child: Opacity(
        opacity: a1.value,
        child: AlertDialog(
          shape: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: borderRadius10),
          title: Text(
            "select_language".tr,
            style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  onTap: () async {
                    homePageController.switchLang('tr');
                    String token = await Auth().getToken();
                    Get.to(() => token == '' ? LoginView() : BottomNavBar());
                  },
                  leading: const CircleAvatar(backgroundImage: AssetImage(tkmIcon), radius: 20),
                  title: const Text('Türkmen',
                      textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18))),
              const SizedBox(
                height: 15,
              ),
              ListTile(
                  onTap: () async {
                    homePageController.switchLang('tr');
                    String token = await Auth().getToken();
                    Get.to(() => token == '' ? LoginView() : BottomNavBar());
                  },
                  leading: const CircleAvatar(backgroundImage: AssetImage(ruIcon), radius: 20),
                  title: const Text('Русский',
                      textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18))),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
