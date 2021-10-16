// ignore_for_file: type_annotate_public_apis, always_declare_return_types, file_names, deprecated_member_use, avoid_bool_literals_in_conditional_expressions, prefer_const_constructors, avoid_print, invariant_booleans

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/Others/Models/ProducerModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Others/Models/ProductsModel.dart';
import '../../Others/constants/constants.dart';
import '../../Others/constants/widgets.dart';
import '../ProductCard.dart';

class Search extends StatefulWidget {
  const Search({Key key, @required this.newInCome}) : super(key: key);

  final String newInCome;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int cartProductNumber = 0;
  String newInCome = "0";
  bool inCartElement = false;
  List list = [];
  bool loading = false;
  List producerName = [];
  int page = 1;
  List<Map<String, dynamic>> priceName;
  int priceValue = -1;
  TextEditingController textEditingController = TextEditingController();

  final RefreshController _refreshController = RefreshController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    newInCome = widget.newInCome ?? "0";
    priceName = [
      {"name": hightolow, "number": 0},
      {"name": lowtohigh, "number": 1}
    ];

    ProducerModel().getProducer().then((value) {
      for (final element in value) {
        producerName.add({
          "id": element.id,
          "name": element.producerName,
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
      "producer_id": null, //jsonEncode([3]),
      "stock_min": null,
      "price": null,
      "new_in_come": newInCome,
    }).then((value) {
      if (value != null) {
        for (final element in value) {
          inCartElement = false;
          cartProductNumber = 0;
          for (final element2 in myList) {
            if (element.id == element2["id"]) {
              inCartElement = true;
              cartProductNumber = element2["cartQuantity"];
            }
          }

          setState(() {
            loading = true;
            list.add({
              "id": element.id,
              "name": element.productName,
              "price": element.price,
              "image": element.images,
              "stockCount": element.stockCount,
              "addCart": inCartElement,
              "cartQuantity": cartProductNumber
            });
          });
        }
      } else {
        setState(() {
          loading = true;
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
    int a = 0;
    a = pageNumber;
    Future.delayed(const Duration(milliseconds: 1000));
    if ((a / 20) > page + 1) {
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
            loading = false;
          });
          getData();
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

  bool newInComeValue = false;
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
                  name: "producer",
                  list: producerName,
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
                CheckboxListTile(
                  value: newInComeValue,
                  checkColor: Colors.white,
                  activeColor: kPrimaryColor,
                  onChanged: (val) {
                    setState(() {
                      newInComeValue = val;
                      if (newInComeValue == true) {
                        newInCome = "1";
                      } else {
                        newInCome = "0";
                      }
                    });
                  },
                  title: Text(
                    "newInCome",
                    style: const TextStyle(
                        color: Colors.black, fontFamily: popPinsRegular),
                  ).tr(),
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
                    list.clear();
                    final List countryId = [];
                    for (final element in producerName) {
                      if (element["isSelected"] == true) {
                        countryId.add(element["id"]);
                      }
                    }

                    Product().getProducts(parametrs: {
                      "page": '$page',
                      "limit": '20',
                      "product_name": textEditingController.text,
                      "new_in_come": newInCome,
                      "producer_id":
                          countryId.isEmpty ? null : jsonEncode(countryId),
                      "price": "${priceValue + 1}",
                    }).then((value) {
                      if (value != null) {
                        for (final element in value) {
                          inCartElement = false;
                          cartProductNumber = 0;
                          for (final element2 in myList) {
                            if (element.id == element2["id"]) {
                              inCartElement = true;
                              cartProductNumber = element2["cartQuantity"];
                            }
                          }

                          setState(() {
                            loading = true;
                            list.add({
                              "id": element.id,
                              "name": element.productName,
                              "price": element.price,
                              "image": element.images,
                              "stockCount": element.stockCount,
                              "addCart": inCartElement,
                              "cartQuantity": cartProductNumber
                            });
                          });
                        }
                      } else if (value == null) {
                        showMessage("noProduct", context, Colors.red);
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
            footer: loadMore("pull_up_to_load"),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: loading
                ? list.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: const Text("noSearch",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: popPinsMedium,
                                fontSize: 24,
                              )).tr(),
                        ),
                      )
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
                            stockCount: list[index]["stockCount"],
                            addCart: list[index]["addCart"],
                            cartQuantity: list[index]["cartQuantity"],
                          );
                        })
                : Center(
                    child: spinKit(),
                  ),
          )),
        ],
      ),
    ));
  }
}

class CheckBoxListBuilder extends StatefulWidget {
  const CheckBoxListBuilder({Key key, this.name, this.list}) : super(key: key);

  final List list;
  final String name;

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
