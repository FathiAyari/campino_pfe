class PostModel {
  String owner;
  String? id;
  String ownerImage;
  String? image;
  String description;
  List<dynamic> likes;
  DateTime creationDate;
  List<dynamic> reportingUser;

  PostModel({
    required this.owner,
    required this.ownerImage,
    this.image,
    this.id,
    required this.reportingUser,
    required this.likes,
    required this.creationDate,
    required this.description,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      owner: json["owner"],
      id: json["id"],
      ownerImage: json["ownerImage"],
      image: json["image"],
      reportingUser: json["reportingUser"],
      description: json["description"],
      likes: json["likes"],
      creationDate: json["creationDate"].toDate(),
    );
  }
  Map<String, dynamic> Tojson() {
    return {
      "owner": owner,
      "image": image,
      "description": description,
      "creationDate": creationDate,
      "ownerImage": ownerImage,
      "likes": likes,
      "reportingUser": reportingUser,
    };
  }
}
