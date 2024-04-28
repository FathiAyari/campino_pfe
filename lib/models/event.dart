class Event {
  String? id;
  String userId;
  String name;
  String description;
  String addresse;
  DateTime start;
  DateTime end;

  Event(
      {required this.userId,
      this.id,
      required this.start,
      required this.description,
      required this.name,
      required this.end,
      required this.addresse});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      end: json["end"].toDate(),
      start: json["start"].toDate(),
      userId: json["userId"],
      addresse: json["addresse"],
      description: json["description"],
      name: json["name"],
    );
  }
}
