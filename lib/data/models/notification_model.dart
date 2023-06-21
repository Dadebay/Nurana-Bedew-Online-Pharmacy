class NotificationModel {
  NotificationModel({
    this.image,
    this.price,
    this.notificationId,
    this.productId,
    this.productName,
  });

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      image: json["destination"],
      price: json["price"],
      notificationId: json["notification_id"],
      productId: json["id"],
      productName: json["product_name"],
    );
  }

  final int? notificationId;
  final int? productId;
  final String? productName;
  final String? price;
  final String? image;
}
