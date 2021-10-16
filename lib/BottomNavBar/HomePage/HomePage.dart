// ignore_for_file: always_declare_return_types, type_annotate_public_apis, file_names

import 'package:flutter/material.dart';
import 'package:medicine_app/BottomNavBar/ProductCard.dart';
import 'package:medicine_app/Others/Models/ProductsModel.dart';
import 'package:medicine_app/Others/constants/constants.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  final String pageName;
  const HomePage({
    Key key,
    this.pageName,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List list = [];
  bool loading = false;
  int page = 1;

  final RefreshController _refreshController = RefreshController();

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  int a = 0;
  getData() {
    Product()
        .getProducts(
            parametrs: widget.pageName == "Nurana Bedew"
                ? {
                    "page": '$page',
                    "limit": '20',
                  }
                : {"page": '$page', "limit": '20', "new_in_come": "1"})
        .then((value) {
      if (value != null) {
        for (final element in value) {
          a = 0;
          for (final element2 in myList) {
            if (element.id == element2["id"]) {
              a = element2["cartQuantity"];
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
              "cartQuantity": a
            });
          });
        }
      } else {
        // showMessage("tryagain", context, Colors.red);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: appBarSearchButton(context, widget.pageName),
        body: SmartRefresher(
          enablePullUp: true,
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
                      stockCount: list[index]["stockCount"],
                      cartQuantity: list[index]["cartQuantity"],
                    );
                  })
              : Center(
                  child: spinKit(),
                ),
        ));
  }
}
