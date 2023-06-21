// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:medicine_app/constants/constants.dart';

import '../../../constants/app_bar_static.dart';

class NewsProfil extends StatelessWidget {
  final String title;
  final String description;

  const NewsProfil({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        name: "NewsPageName",
        backArrow: true,
        onTap: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratSemiBold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                description,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: montserratRegular),
              ),
            )
          ],
        ),
      ),
    );
  }
}
