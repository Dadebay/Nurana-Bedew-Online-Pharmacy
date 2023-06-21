import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/buttons/add_cart_button.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';
import 'package:medicine_app/data/models/products_model.dart';
import 'package:medicine_app/data/services/products_service.dart';
import 'product_photo_view.dart';

class ProductProfil extends StatefulWidget {
  const ProductProfil({
    Key? key,
    required this.id,
    required this.name,
    required this.stockCount,
    required this.imaqe,
    required this.price,
  }) : super(key: key);

  final int id;
  final String name;
  final String imaqe;
  final String price;
  final int stockCount;

  @override
  _ProductProfilState createState() => _ProductProfilState();
}

class _ProductProfilState extends State<ProductProfil> {
  TextEditingController controller = TextEditingController();

  Container image({required ProductByIDModel product}) {
    return Container(
        height: 400,
        color: backgroundColor,
        child: GestureDetector(
            onTap: () {
              Get.to(() => PhotoViewPage(image: "$serverURL/${product.images}-big.webp"));
            },
            child: CachedNetworkImage(
                width: double.infinity,
                colorBlendMode: BlendMode.difference,
                imageUrl: "$serverURL/${product.images}-big.webp",
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                placeholder: (context, url) => Center(child: spinKit()),
                errorWidget: (context, url, error) => Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        "assets/icons/logo.png",
                        color: Colors.grey,
                      ),
                    ))));
  }

  dynamic selectCount() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "maximum2".tr,
              style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontFamily: montserratMedium, color: Colors.black),
            decoration: InputDecoration(
                isDense: true,
                hintText: "${"maximum".tr} : ${widget.stockCount}",
                hintStyle: TextStyle(color: Colors.grey[400], fontFamily: montserratMedium),
                border: OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey.shade200))),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          width: Get.size.width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                backgroundColor: kPrimaryColor,
                elevation: 1,
                shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
              ),
              onPressed: () {},
              child: Text(
                "agree".tr,
                style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.white),
              )),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(widget.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratMedium)),
      ),
      bottomSheet: Container(
          color: Colors.white,
          child: AddCartButton(
            id: widget.id,
            productProfil: true,
            stockCount: widget.stockCount,
            image: "$serverURL/${widget.imaqe}-big.webp",
            name: widget.name,
            price: widget.price,
          )),
      body: FutureBuilder<ProductByIDModel>(
        future: ProductsService().getProductById(widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: spinKit());
          } else if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.hasData == null) {
            return const Text("Null");
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                image(product: snapshot.data),
                dividerr(),
                dividerr(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(children: [
                    Text(
                      "${snapshot.data.productName}",
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 22),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    textWidgets(text1: "price".tr, text2: snapshot.data.price!, tmt: true, fontSize: 16.0),
                    textWidgets(text1: "dateOfExpire".tr, text2: "${snapshot.data.dateOfExpire!.substring(0, 10)}", fontSize: 16.0),
                    textWidgets(text1: "quantity".tr, text2: "${snapshot.data.quantity}", fontSize: 16.0),
                    textWidgets(text1: "producer".tr, text2: "${snapshot.data.producerName}", fontSize: 16.0),
                    if (snapshot.data.descriptionTm != null || snapshot.data.descriptionRu != null)
                      textWidgets(text1: "descriptionTm".tr, text2: "${snapshot.data.descriptionTm ?? snapshot.data.descriptionRu}", fontSize: 16.0)
                    else
                      const SizedBox.shrink(),
                  ]),
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
