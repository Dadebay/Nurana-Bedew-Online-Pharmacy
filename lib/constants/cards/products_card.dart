import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constants/constants.dart';
import 'package:medicine_app/constants/widgets.dart';

import '../../data/models/products_model.dart';
import '../../views/product_profil/product_profil_view.dart';
import '../buttons/add_cart_button.dart';

class ProductCard extends StatefulWidget {
  final ProductModel model;
  final bool orderedProductView;
  const ProductCard({
    required this.model,
    required this.orderedProductView,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => ProductProfil(
                id: widget.model.id!,
                stockCount: widget.model.stockCount!,
                name: widget.model.name!,
                imaqe: widget.model.name!,
                price: widget.model.price!,
              ));
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imagePart(),
            textPart(),
            AddCartButton(
              id: widget.model.id!,
              stockCount: widget.model.stockCount!,
              productProfil: false,
              image: "$serverURL/${widget.model.images!}-big.webp",
              name: widget.model.name!,
              price: widget.model.price!,
            )
          ],
        ),
      ),
    );
  }

  Column textPart() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            widget.model.name!,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                "price".tr,
                style: const TextStyle(color: Colors.grey, fontFamily: montserratRegular, fontSize: 14),
              ),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: " ${widget.model.price}", style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black)),
                    const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 12, color: Colors.black))
                  ]),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Expanded imagePart() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: borderRadius10),
        child: ClipRRect(
          borderRadius: borderRadius10,
          child: CachedNetworkImage(
              width: double.infinity,
              colorBlendMode: BlendMode.difference,
              imageUrl: "$serverURL/${widget.model.images}-mini.webp",
              imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
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
                  )),
        ),
      ),
    );
  }
}
