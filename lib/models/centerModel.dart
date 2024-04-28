class CenterModel {
  String? id;
  String ownerId;
  String name;
  double latitude;
  double langitude;
  DateTime creationDate;
  List<dynamic> images;
  String adresse;
  String? description;
  String Gsm;

  CenterModel({
    required this.name,
    required this.images,
    required this.Gsm,
    this.description,
    required this.creationDate,
    required this.latitude,
    required this.langitude,
    required this.adresse,
    this.id,
    required this.ownerId,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      name: json["name"],
      Gsm: json["Gsm"],
      langitude: json["langitude"],
      latitude: json["latitude"],
      creationDate: json["creationDate"].toDate(),
      adresse: json["adresse"],
      id: json["id"],
      images: json["images"],
      description: json["description"],
      ownerId: json["ownerId"],
    );
  }
  Map<String, dynamic> Tojson(String id) {
    return {
      "name": name,
      'id': id,
      "ownerId": ownerId,
      "latitude": latitude,
      "langitude": langitude,
      "creationDate": creationDate,
      "adresse": adresse,
      "Gsm": Gsm,
      'images': images,
      'description': description
    };
  }
}
