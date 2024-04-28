class EventReservation {
  String? id;
  String userId;
  String eventId;

  bool status;

  EventReservation({required this.eventId, required this.userId, required this.status, this.id});

  factory EventReservation.fromJson(Map<String, dynamic> json) {
    return EventReservation(
      id: json["id"],
      eventId: json["eventId"],
      userId: json["userId"],
      status: json["status"],
    );
  }
  Map<String, dynamic> Tojson(String id) {
    return {
      'id': id,
      "eventId": eventId,
      "userId": userId,
      "status": status,
    };
  }
}
