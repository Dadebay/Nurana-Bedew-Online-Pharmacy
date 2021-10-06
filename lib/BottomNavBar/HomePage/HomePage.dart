// ignore_for_file: always_declare_return_types, type_annotate_public_apis, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:medicine_app/BottomNavBar/ProductCard.dart';
import 'package:medicine_app/Others/Models/ProductsModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'SearchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool animation = false;
  List list = [];
  bool loading = false;
  int page = 1;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _onRefresh() {
    if (mounted) {
      setState(() {
        page = 1;
        list.clear();
        loading = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 1000), () {});
    getData();
    _refreshController.refreshCompleted();
  }

  getData() {
    Product()
        .getProducts(parametrs: {"page": '$page', "limit": '20'}).then((value) {
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
    });
  }

  void _onLoading() {
    Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        page += 1;
        getData();
      });
    }
    _refreshController.loadComplete();
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: kPrimaryColor,
      title: const Text(
        "Nurana Bedew",
        style: TextStyle(color: Colors.white, fontFamily: popPinsSemiBold),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const Search(
                      categoryId: -1,
                      // categoryId: ,
                    )));
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(IconlyLight.search, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: appBar(),
        body: SmartRefresher(
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          primary: true,
          header: const MaterialClassicHeader(
            color: kPrimaryColor,
          ),
          footer: loadMore(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: loading
              ? GridView.builder(
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
        ));
  }
}
