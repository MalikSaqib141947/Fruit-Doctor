import 'package:flutter/material.dart';
import 'package:flutter_doctor/Screens/todo_list_screen.dart';

import 'note_home.dart';

class Todoist extends StatelessWidget {
  static const String id = "Todoist";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white70,
        body:Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteHome()));
                    },
                    child: Card(
                      elevation: 15,
                      child: Image(image: AssetImage("assets/images/notes.png"),),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoListScreen()));
                    },
                    child: Card(
                      elevation: 15,
                      child: Image(image: AssetImage("assets/images/todo.png"),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),

    );
  }
}
