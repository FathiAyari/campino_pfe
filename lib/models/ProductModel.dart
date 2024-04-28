class Product {
  String owner;
  String id;
  String name;
  String ownerImage;
  String image;
  String description;
  DateTime creationDate;
  String adresse;
  double price;
  bool state;
  bool sold;
  Product({
    required this.owner,
    required this.id,
    required this.name,
    required this.ownerImage,
    required this.image,
    required this.creationDate,
    required this.description,
    required this.adresse,
    required this.price,
    required this.state,
    required this.sold,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      owner: json["owner"],
      id: json["id"],
      name: json["name"],
      ownerImage: json["ownerImage"],
      image: json["image"],
      description: json["description"],
      creationDate: json["creationDate"].toDate(),
      adresse: json["adresse"],
      price: json["price"],
      state: json["state"],
      sold: json["sold"],
    );
  }
  Map<String, dynamic> Tojson(String id) {
    return {
      "owner": owner,
      "image": image,
      "description": description,
      "creationDate": creationDate,
      "ownerImage": ownerImage,
      "adresse": adresse,
      "price": price,
      "state": state,
      "name": name,
      "sold": sold,
      "id": id,
    };
  }
}
