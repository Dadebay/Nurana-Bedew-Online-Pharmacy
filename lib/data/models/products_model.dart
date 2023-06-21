class ProductByIDModel {
  ProductByIDModel({this.id, this.stockCount, this.price, this.descriptionRu, this.descriptionTm, this.dateOfExpire, this.productName, this.images, this.producerName, this.quantity});

  factory ProductByIDModel.fromJson(Map<String, dynamic> json) {
    return ProductByIDModel(
      id: json["id"],
      productName: json["product_name"],
      price: json["price"],
      stockCount: json["stock_count"],
      quantity: json['quantity'],
      producerName: json["producer_name"],
      descriptionTm: json["description_tm"],
      descriptionRu: json["description_ru"],
      dateOfExpire: json["date_of_expire"],
      images: json["image"],
    );
  }

  final int? quantity;
  final int? stockCount;
  final String? id;
  final String? productName;
  final String? price;
  final String? descriptionRu;
  final String? descriptionTm;
  final String? dateOfExpire;
  final String? images;
  final String? producerName;
}

class ProductModel {
  ProductModel({
    this.id,
    this.stockCount,
    this.price,
    this.name,
    this.images,
  });

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? 0,
      name: json["product_name"] ?? 'Ady yok',
      stockCount: json["stock_count"] ?? 0,
      price: json["price"] ?? 0,
      images: json["image"] ?? '',
    );
  }

  final int? id;
  final int? stockCount;
  final String? images;
  final String? price;
  final String? name;
}

class OrderedProductProfilModel {
  OrderedProductProfilModel({
    this.id,
    this.quantity,
    this.price,
    this.name,
    this.images,
  });

  factory OrderedProductProfilModel.fromJson(Map<dynamic, dynamic> json) {
    return OrderedProductProfilModel(
      id: json["id"] ?? 0,
      name: json["product_name"] ?? 'Ady yok',
      quantity: json["quantity"] ?? 0,
      price: json["price"] ?? 0,
      images: json["image"] ?? '',
    );
  }

  final int? id;
  final int? quantity;
  final String? images;
  final String? price;
  final String? name;
}
