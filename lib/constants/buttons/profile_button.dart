import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key, required this.name, required this.icon, required this.onTap}) : super(key: key);
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      focusColor: Colors.white,
      selectedColor: Colors.white,
      hoverColor: Colors.white,
      selectedTileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xfff1f2f4).withOpacity(0.6), borderRadius: borderRadius15),
        child: Icon(
          icon,
          color: Colors.black,
          size: 26,
        ),
      ),
      title: Text(
        name.tr,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
      ),
      trailing: const Icon(
        IconlyLight.arrowRightCircle,
        color: Colors.black,
        size: 18,
      ),
    );
  }
}
