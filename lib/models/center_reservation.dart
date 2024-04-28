class CenterReservation {
  String? id;
  String userId;
  String centerId;
  DateTime start;
  DateTime end;
  int persons;
  bool status;

  CenterReservation(
      {required this.start,
      required this.centerId,
      required this.end,
      required this.userId,
      required this.status,
      this.id,
      required this.persons});

  factory CenterReservation.fromJson(Map<String, dynamic> json) {
    return CenterReservation(
      id: json["id"],
      centerId: json["centerId"],
      userId: json["userId"],
      status: json["status"],
      persons: json["persons"],
      start: json["start"].toDate(),
      end: json["end"].toDate(),
    );
  }
  Map<String, dynamic> Tojson(String id) {
    return {
      'id': id,
      "centerId": centerId,
      "userId": userId,
      "status": status,
      "end": end,
      "start": start,
      "persons": persons,
    };
  }
}
