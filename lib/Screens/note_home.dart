import 'package:flutter/material.dart';
import 'package:flutter_doctor/Model/note.dart';
import 'package:flutter_doctor/Widget/loading.dart';
import 'package:flutter_doctor/Services/notedb.dart';
import 'package:flutter_doctor/Screens/note_edit.dart';
import 'package:flutter_doctor/utilities/constants.dart';

class NoteHome extends StatefulWidget {
  static const String id = "NoteHome";
  @override
  _NoteHomeState createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  List<Note> notes;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('NOTES'),
            centerTitle: true,
            backgroundColor: primary_Color),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primary_Color,
          child: Icon(Icons.add),
          onPressed: () {
            setState(() => loading = true);
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteEdit(note: new Note())))
                .then((v) {
              refresh();
            });
          },
        ),
        body: loading
            ? Loading()
            : ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  Note note = notes[index];
                  return Card(
                    color: Colors.white70,
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        setState(() => loading = true);
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoteEdit(note: note)))
                            .then((v) {
                          refresh();
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> refresh() async {
    notes = await DB().getNotes();
    setState(() => loading = false);
  }
}
