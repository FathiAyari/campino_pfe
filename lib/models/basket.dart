class Basket {
  final String productId;
  final DateTime time;

  Basket({required this.productId, required this.time});

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(productId: json['productId'], time: json['time'].toDate());
  }
}
