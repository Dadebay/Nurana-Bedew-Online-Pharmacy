class CartModel {
  CartModel({
    this.id,
    this.stockCount,
    this.quantity,
    this.price,
    this.productName,
    this.images,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(id: json["id"], productName: json["product_name"], stockCount: json["stock_count"], price: json["price"], quantity: json["quantity"], images: json["image"]);
  }

  final int? id;
  final int? quantity;
  final int? stockCount;
  final String? images;
  final String? price;
  final String? productName;
}
