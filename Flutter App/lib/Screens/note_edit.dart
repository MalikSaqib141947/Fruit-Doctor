import 'package:flutter/material.dart';
import 'package:flutter_doctor/Model/note.dart';
import 'package:flutter_doctor/Widget/loading.dart';
import 'package:flutter_doctor/Services/notedb.dart';
import 'package:flutter_doctor/utilities/constants.dart';

class NoteEdit extends StatefulWidget {
  static const String id = "NoteEdit";
  final Note note;
  NoteEdit({this.note});

  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  DateTime now = DateTime.now();
  TextEditingController title, content;
  bool loading = false, editmode = false;

  @override
  void initState() {
    super.initState();
    title = new TextEditingController(text: 'Title');
    content = new TextEditingController(text: 'Hello');
    if (widget.note.id != null) {
      editmode = true;
      title.text = widget.note.title;
      content.text = widget.note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editmode ? 'EDIT' : 'NEW'),
        backgroundColor: primary_Color,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              setState(() => loading = true);
              save();
            },
          ),
          if (editmode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() => loading = true);
                delete();
              },
            ),
        ],
      ),
      body: loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.all(13.0),
              children: <Widget>[
                Text(now.day.toString() +
                    "/" +
                    now.month.toString() +
                    "/" +
                    now.year.toString()),
                SizedBox(
                  height: 7,
                ),
                TextField(
                  controller: title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: content,
                  maxLines: 27,
                ),
              ],
            ),
    );
  }

  Future<void> save() async {
    if (title.text != '') {
      widget.note.title = title.text;
      widget.note.content = content.text;
      if (editmode)
        await DB().update(widget.note);
      else
        await DB().add(widget.note);
    }
    setState(() => loading = false);
  }

  Future<void> delete() async {
    await DB().delete(widget.note);
    Navigator.pop(context);
  }
}
