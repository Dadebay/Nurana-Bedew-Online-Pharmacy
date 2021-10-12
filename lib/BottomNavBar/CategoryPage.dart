// ignore_for_file: file_names, avoid_bool_literals_in_conditional_expressions

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/Others/Models/CategoryModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage/SearchPage.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List category = [];
  bool wait = false;
  String all = tr('all');
  String newAdded = tr('new');

  @override
  void initState() {
    super.initState();
    category.add({
      "id": -1,
      "name": all,
    });
    category.add({
      "id": -1,
      "name": newAdded,
    });

    Category().getCategory().then((value) {
      for (final element in value) {
        category.add({"id": element.id, "name": element.categoryName});
      }
      setState(() {
        wait = true;
      });
    });
  }

  Future<String> getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(langKey);
  }

  String lang = "tm";

  setData() {
    setState(() {
      getData().then((value) {
        lang = value ?? "tm";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: appBar("categoryName"),
          body: wait == false
              ? spinKit()
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: category.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width <= 800 ? 2 : 4,
                      childAspectRatio: 6 / 4),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => Search(
                                    categoryId: category[index]["id"],
                                    newInCome: index == 1 ? "1" : "0",
                                  )));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            borderRadius: borderRadius10,
                            child: Center(
                              child: Text(category[index]["name"],
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontFamily:
                                          lang == "tm" ? null : popPinsMedium,
                                      fontWeight: lang == "tm"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 15)),
                            ),
                          ),
                        ));
                  })),
    );
  }
}
