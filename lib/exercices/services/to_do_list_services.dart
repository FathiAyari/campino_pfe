import 'package:campino_pfe/exercices/model/to_do_list.dart';
import 'package:campino_pfe/exercices/view/edit_element.dart';
import 'package:campino_pfe/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoListServices {
  var toDoListCollection = FirebaseFirestore.instance.collection('list');
  // use streambuilder to get data and visualize real time changes

  Widget getToDoLists() {
    return StreamBuilder<QuerySnapshot>(
        stream: toDoListCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ToDoList> data = [];
            var fireBaseData = snapshot.data!.docs.toList();
            for (var line in fireBaseData) {
              data.add(ToDoList.fromJson(line.data() as Map<String, dynamic>));
            }
            // use listview builder to display data from data source dynamicly
            if (data.isEmpty) {
              return Center(
                child: Text("no data"),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.02, horizontal: Constants.screenWidth * 0.03),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.pink.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          subtitle: Text("${DateFormat("yyyy/MM/dd").format(data[index].date!)}"),
                          trailing: Container(
                            width: Constants.screenWidth * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => EditElementView(toDoList: data[index])));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteElement(data[index].id!);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text("${data[index].label}"),
                        ),
                      );
                    }),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future addToDoElement(ToDoList toDoList) async {
    var doc = toDoListCollection.doc();
    toDoListCollection.doc(doc.id).set(toDoList.toJson());
    toDoListCollection.doc(doc.id).update({"id": doc.id});
  }

  Future deleteElement(String elementId) async {
    await toDoListCollection.doc(elementId).delete();
  }

  Future editElement(ToDoList toDoList) async {
    await toDoListCollection.doc(toDoList.id).update(toDoList.toJson());
  }
}
