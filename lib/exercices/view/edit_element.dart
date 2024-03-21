import 'package:campino_pfe/exercices/model/to_do_list.dart';
import 'package:campino_pfe/exercices/services/to_do_list_services.dart';
import 'package:campino_pfe/presentation/ressources/dimensions/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../presentation/components/input_field/input_field.dart';

class EditElementView extends StatefulWidget {
  final ToDoList toDoList;
  const EditElementView({Key? key, required this.toDoList}) : super(key: key);

  @override
  State<EditElementView> createState() => _EditElementViewState();
}

class _EditElementViewState extends State<EditElementView> {
  late DateTime dateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() {
    setState(() {
      dateTime = widget.toDoList.date!;
      labelController.text = widget.toDoList.label!;
    });
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController labelController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01),
                    child: InputField(label: "label", textInputType: TextInputType.text, controller: labelController),
                  ),
                  Container(
                      width: Constants.screenWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07),
                        child: ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(), //get today's date
                                      firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101))
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    dateTime = value;
                                  });
                                }
                              });
                            },
                            child: Text("${DateFormat("yyyy/MM/dd").format(dateTime)}")),
                      )),
                  Container(
                    width: Constants.screenWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ToDoListServices()
                                  .editElement(ToDoList(date: dateTime, label: labelController.text, id: widget.toDoList.id))
                                  .then((value) => Navigator.pop(context));
                            }
                          },
                          child: Text('Modifier')),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
