import 'package:campino_pfe/exercices/services/to_do_list_services.dart';
import 'package:campino_pfe/exercices/view/add_to_do_element.dart';
import 'package:flutter/material.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoElement()));
        },
        child: Icon(Icons.add),
      ),
      body: ToDoListServices().getToDoLists(),
    ));
  }
}
