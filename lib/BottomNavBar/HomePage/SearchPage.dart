// ignore_for_file: type_annotate_public_apis, always_declare_return_types, file_names, deprecated_member_use, avoid_bool_literals_in_conditional_expressions, prefer_const_constructors

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/Others/Models/CategoryModel.dart';
import 'package:medicine_app/Others/Models/CountryModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Others/Models/ProductsModel.dart';
import '../../Others/constants/constants.dart';
import '../../Others/constants/widgets.dart';
import '../ProductCard.dart';

class Search extends StatefulWidget {
  const Search({Key key, this.categoryId}) : super(key: key);

  final int categoryId;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List categoryName = [];
  int categoryValue = -1;
  List list = [];
  bool loading = false;
  List locationName = [];
  int locationValue = -1;
  List<Map<String, dynamic>> minSany = [
    {"name": "10", "isSelected": false},
    {"name": "20", "isSelected": false},
    {"name": "30", "isSelected": false},
    {"name": "40", "isSelected": false},
    {"name": "50", "isSelected": false},
    {"name": "100", "isSelected": false},
  ];
  int minValue = -1;
  int page = 1;
  String hightolow = tr('hightolow');
  String lowtohigh = tr('lowtohigh');

  int priceValue = -1;
  TextEditingController textEditingController = TextEditingController();

  final RefreshController _refreshController = RefreshController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> priceName;
  @override
  void initState() {
    super.initState();
    priceName = [
      {"name": hightolow, "isSelected": true, "number": 0},
      {"name": lowtohigh, "isSelected": false, "number": 1}
    ];

    CountryModel().getCountries().then((value) {
      for (final element in value) {
        locationName.add({
          "id": element.id,
          "name": element.countryName,
          "isSelected": false
        });
      }
    });

    Category().getCategory().then((value) {
      for (final element in value) {
        categoryName.add({
          "id": element.id,
          "name": element.categoryName,
          "isSelected": false
        });
      }
    });

    getData();
  }

  getData() {
    Product().getProducts(parametrs: {
      "page": '$page', "limit": '20',
      "product_name": textEditingController.text,
      "country_id": null, //jsonEncode([3]),
      "stock_min": null,
      "price": null,
      "category_id":
          widget.categoryId == -1 ? [] : jsonEncode([widget.categoryId])
    }).then((value) {
      if (value != null) {
        for (final element in value) {
          setState(() {
            loading = true;
            list.add({
              "id": element.id,
              "name": element.productName,
              "price": element.price,
              "image": element.images
            });
          });
        }
      } else {
        setState(() {
          load = true;
        });
      }
    });
  }

  void _onRefresh() {
    if (mounted) {
      setState(() {
        textEditingController.clear();
        page = 1;
        list.clear();
        loading = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 1000), () {});
    getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    Future.delayed(const Duration(milliseconds: 1000));
    if (mounted && load == false) {
      setState(() {
        page += 1;
        getData();
      });
    }
    _refreshController.loadComplete();
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            IconlyLight.arrowLeft2,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                IconlyLight.filter,
                color: Colors.white,
              ),
            ),
          )
        ],
        centerTitle: true,
        title: const Text(
          "search",
          style: TextStyle(
            color: Colors.white,
            fontFamily: popPinsSemiBold,
          ),
        ).tr());
  }

  Padding searchTextField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: textEditingController,
        style: const TextStyle(
            color: Colors.black, fontFamily: popPinsMedium, fontSize: 17),
        cursorColor: kPrimaryColor,
        onEditingComplete: () {
          setState(() {
            list.clear();
          });
          Product().getProducts(parametrs: {
            "page": '$page', "limit": '20',
            "product_name": textEditingController.text,
            "country_id": null, //jsonEncode([3]),
            "stock_min": null,
            "price": null,
            "category_id":
                widget.categoryId == -1 ? [] : jsonEncode([widget.categoryId])
          }).then((value) {
            setState(() {
              loading = true;
              if (value.isEmpty) list.clear();
            });
            for (final element in value) {
              list.add({
                "id": element.id,
                "name": element.productName,
                "price": element.price,
                "image": element.images
              });
            }
          });
        },
        decoration: InputDecoration(
          hintText: search,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          prefixIcon: textEditingController.text.isEmpty
              ? const Icon(
                  IconlyLight.search,
                  color: Colors.black,
                )
              : const Icon(
                  IconlyBold.search,
                  color: kPrimaryColor,
                ),
          hintStyle:
              const TextStyle(color: Colors.black38, fontFamily: popPinsMedium),
          filled: true,
          fillColor: Colors.grey[200],
          focusedBorder: const OutlineInputBorder(
              borderRadius: borderRadius10,
              borderSide: BorderSide(color: kPrimaryColor, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius10,
              borderSide: BorderSide(color: Colors.grey[200], width: 2)),
        ),
      ),
    );
  }

  Drawer endDrawer(Size size) {
    return Drawer(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: const Text(
                    "search",
                    style: TextStyle(
                        fontFamily: popPinsMedium,
                        fontSize: 18,
                        color: Colors.black),
                  ).tr(),
                ),
                dividerr(),
                CheckBoxListBuilder(
                  name: "location",
                  list: locationName,
                ),

                // ),

                dividerr(),
                CheckBoxListBuilder(
                  name: "categoryName",
                  list: categoryName,
                ),

                dividerr(),
                ExpansionTile(
                  title: const Text("priceName",
                      style: TextStyle(
                        fontFamily: popPinsMedium,
                      )).tr(),
                  collapsedIconColor: Colors.grey,
                  iconColor: kPrimaryColor,
                  textColor: kPrimaryColor,
                  collapsedTextColor: Colors.grey,
                  children: [
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          value: index,
                          activeColor: kPrimaryColor,
                          groupValue: priceValue,
                          onChanged: (ind) {
                            setState(() {
                              priceValue = ind;
                            });
                          },
                          title: Text(
                            priceName[index]["name"],
                            style: const TextStyle(fontFamily: popPinsRegular),
                          ),
                        );
                      },
                      itemCount: priceName.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
                dividerr(),
                ExpansionTile(
                  title: const Text("minSany",
                      style: TextStyle(
                        fontFamily: popPinsMedium,
                      )).tr(),
                  collapsedIconColor: Colors.grey,
                  iconColor: kPrimaryColor,
                  textColor: kPrimaryColor,
                  collapsedTextColor: Colors.grey,
                  children: [
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          value: index,
                          activeColor: kPrimaryColor,
                          groupValue: minValue,
                          onChanged: (ind) {
                            setState(() {
                              minValue = ind;
                              for (final element in minSany) {
                                element["isSelected"] = false;
                              }
                              minSany[index]["isSelected"] = true;
                            });
                          },
                          title: Text(
                            minSany[index]["name"],
                            style: const TextStyle(fontFamily: popPinsRegular),
                          ),
                        );
                      },
                      itemCount: minSany.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
                dividerr(),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: SizedBox(
              width: size.width,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: kPrimaryColor,
                  elevation: 1,
                  shape:
                      const RoundedRectangleBorder(borderRadius: borderRadius5),
                  onPressed: () {
                    final List countryId = [];
                    for (final element in locationName) {
                      if (element["isSelected"] == true) {
                        countryId.add(element["id"]);
                      }
                    }
                    final List category = [];
                    for (final element in categoryName) {
                      if (element["isSelected"] == true) {
                        category.add(element["id"]);
                      }
                    }
                    String abc;
                    for (final element in minSany) {
                      if (element["isSelected"] == true) abc = element["name"];
                    }
                    bool priceSendValue;
                    setState(() {
                      if (priceValue == -1) {
                        priceSendValue = null;
                      } else {
                        priceSendValue = priceName[priceValue]["isSelected"];
                      }
                      list.clear();
                    });
                    Product().getProducts(parametrs: {
                      "page": '$page',
                      "limit": '20',
                      "product_name": textEditingController.text,
                      "country_id":
                          countryId.isEmpty ? null : jsonEncode(countryId),
                      "stock_min": abc,
                      "price": priceSendValue,
                      "category_id": category.isEmpty
                          ? widget.categoryId == -1
                              ? []
                              : jsonEncode([widget.categoryId])
                          : jsonEncode(category)
                    }).then((value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          for (final element in value) {
                            list.add({
                              "id": element.id,
                              "name": element.productName,
                              "price": element.price,
                              "image": element.images
                            });
                          }
                        });
                      } else {
                        showMessage("noProduct", context);
                      }
                    });
                  },
                  child: Text(
                    "search",
                    style: TextStyle(
                        fontFamily: popPinsMedium,
                        fontSize: 18,
                        color: Colors.white),
                  ).tr()),
            ),
          ),
        ],
      ),
    );
  }

  bool load = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      endDrawer: endDrawer(size),
      endDrawerEnableOpenDragGesture: false,
      appBar: appBar(context),
      body: Column(
        children: [
          searchTextField(),
          Expanded(
              child: SmartRefresher(
            enablePullUp: list.isEmpty ? false : true,
            physics: const BouncingScrollPhysics(),
            primary: true,
            header: const MaterialClassicHeader(
              color: kPrimaryColor,
            ),
            footer: loadMore(load ? "" : "pull_up_to_load"),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: loading
                ? list.isEmpty
                    ? Center(child: Image.asset("assets/images/noSearch.png"))
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size.width <= 800 ? 2 : 4,
                            childAspectRatio: 3 / 4.5),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductCard(
                            id: list[index]["id"],
                            name: list[index]["name"],
                            price: list[index]["price"],
                            imagePath: list[index]["image"],
                          );
                        })
                : SizedBox(
                    height: size.height / 1.5,
                    child: Center(
                      child: spinKit(),
                    ),
                  ),
          )),
        ],
      ),
    ));
  }
}

class CheckBoxListBuilder extends StatefulWidget {
  final String name;
  final List list;
  const CheckBoxListBuilder({Key key, this.name, this.list}) : super(key: key);
  @override
  CheckBoxListBuilderState createState() {
    return CheckBoxListBuilderState();
  }
}

class CheckBoxListBuilderState extends State<CheckBoxListBuilder> {
  int value;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.name,
          style: const TextStyle(
            fontFamily: popPinsMedium,
          )).tr(),
      collapsedIconColor: Colors.grey,
      iconColor: kPrimaryColor,
      textColor: kPrimaryColor,
      collapsedTextColor: Colors.grey,
      children: [
        ListView.builder(
          itemBuilder: (context, index) {
            return CheckboxListTile(
              value: widget.list[index]["isSelected"],
              checkColor: Colors.white,
              activeColor: kPrimaryColor,
              onChanged: (val) {
                setState(() {
                  widget.list[index]["isSelected"] = val;
                });
              },
              title: Text(
                widget.list[index]["name"],
                style: const TextStyle(
                    color: Colors.black, fontFamily: popPinsRegular),
              ).tr(),
            );
          },
          itemCount: widget.list.length,
          shrinkWrap: true,
        ),
      ],
    );
  }
}
