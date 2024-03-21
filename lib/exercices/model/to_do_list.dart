class ToDoList {
  String? id;
  String? label;
  DateTime? date;

  ToDoList({this.id, this.label, this.date});

  factory ToDoList.fromJson(Map<String, dynamic> json) {
    return ToDoList(id: json['id'], label: json['label'], date: json['date'].toDate());
  }
  // fromJson is used to get data from json and convert it into a specific object

  Map<String, dynamic> toJson() => {
        'label': this.label,
        'date': this.date,
      };
  // toJson is used to make an object from specific class instance to json object
}
