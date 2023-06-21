class OrdersModel {
  final int? id;
  final String? createdAt;
  final String? totalPrice;

  OrdersModel({this.id, this.createdAt, this.totalPrice});

  factory OrdersModel.fromJson(Map<dynamic, dynamic> json) {
    return OrdersModel(id: json["id"], createdAt: json["created_at"], totalPrice: json["total_price"]);
  }
}
