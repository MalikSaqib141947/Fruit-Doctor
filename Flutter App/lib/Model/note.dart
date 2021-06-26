class Note {

  int id, date;
  String title, content;

  setDate() {
    DateTime now = DateTime.now();
    String ds = now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString();
    date = int.parse(ds);
  }

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    title = map['title'];
    content = map['content'];
  }

  toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'title': title,
      'content': content,
    };
  }

}