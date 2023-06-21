// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/data/services/news_service.dart';

import '../../../constants/app_bar_static.dart';
import '../../../data/models/news_model.dart';
import 'news_profil_view.dart';

class News extends StatefulWidget {
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          name: "NewsPageName",
          backArrow: false,
          onTap: () {},
        ),
        body: FutureBuilder<List<NewsModel>>(
          future: NewsService().getNews(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data.toString() == '[]') {
              return Center(child: Text("noNews".tr));
            } else if (snapshot.hasError) {
              return Center(child: Text("errorNoData".tr));
            } else if (snapshot.hasData) {
              return hasData(snapshot);
            }
            return Center(
              child: spinKit(),
            );
          },
        ));
  }

  ListView hasData(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Get.to(() => NewsProfil(title: snapshot.data[index].title, description: snapshot.data[index].description));
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data[index].title, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 17)),
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 10),
                            child: Text(snapshot.data[index].description,
                                maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 15)),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(IconlyLight.arrowRightCircle, color: Colors.black, size: 24),
                    ),
                  ],
                ),
                dividerr()
              ],
            ),
          ),
        );
      },
    );
  }
}
