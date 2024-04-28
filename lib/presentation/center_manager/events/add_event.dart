import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class AddEvenet extends StatefulWidget {
  const AddEvenet({Key? key}) : super(key: key);

  @override
  State<AddEvenet> createState() => _AddEvenetState();
}

class _AddEvenetState extends State<AddEvenet> {
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController personsController = TextEditingController();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.indigo, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ajouter evenement ',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champ obligatoire";
                  }
                },
                controller: nameController,
                decoration: InputDecoration(
                    label: Text("Nom d'evenement"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champ obligatoire";
                  }
                },
                controller: adresseController,
                decoration: InputDecoration(
                    label: Text("Adresse d'evenement"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champ obligatoire";
                  }
                },
                keyboardType: TextInputType.number,
                controller: personsController,
                decoration: InputDecoration(
                    label: Text("Nombre de personnes "), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champ obligatoire";
                  }
                },
                keyboardType: TextInputType.text,
                maxLines: 5,
                controller: descriptionController,
                decoration: InputDecoration(
                    label: Text("Description d'evenement"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              start = value;
                            });
                          }
                        });
                      },
                      child: Text("date de debut :${DateFormat('yyyy/MM/dd').format(start)}"))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              end = value;
                            });
                          }
                        });
                      },
                      child: Text("date de fin :${DateFormat('yyyy/MM/dd').format(end)}"))),
            ),
            loading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              var user = GetStorage().read('user');

                              if (_formKey.currentState!.validate()) {
                                if (start.isAfter(end)) {
                                  final snackBar = SnackBar(
                                    content: const Text('date de debut doit etre superieur au date de fin'),
                                    backgroundColor: (Colors.red),
                                    action: SnackBarAction(
                                      label: 'fermer',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                                  var doc = FirebaseFirestore.instance.collection('events').doc();
                                  doc.set({
                                    'userId': user['uid'],
                                    'addresse': adresseController.text,
                                    'persons': personsController.text,
                                    'end': end,
                                    'name': nameController.text,
                                    'description': descriptionController.text,
                                    'start': start,
                                    'id': doc.id
                                  });

                                  setState(() {
                                    loading = false;
                                  });
                                  nameController.clear();
                                  personsController.clear();
                                  descriptionController.clear();
                                  adresseController.clear();
                                }
                              }
                            },
                            child: Text("Ajouter"))),
                  )
          ],
        ),
      ),
    );
  }
}
