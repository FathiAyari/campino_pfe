class Message {
  String sender;
  String receiver;
  String content;
  DateTime date;

  Message(
      {required this.sender,
      required this.receiver,
      required this.content,
      required this.date});
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json["name"],
      receiver: json["Gsm"],
      date: json["langitude"],
      content: json["content"],
    );
  }
  Map<String, dynamic> Tojson() {
    return {
      "sender": sender,
      "receiver": receiver,
      "content": content,
      "date": date,
    };
  }
}
