import 'package:campino/models/centerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Makereservation extends StatefulWidget {
  final CenterModel centerModel;
  const Makereservation({Key? key, required this.centerModel}) : super(key: key);

  @override
  State<Makereservation> createState() => _MakereservationState();
}

class _MakereservationState extends State<Makereservation> {
  TextEditingController persoonsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.indigo, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Reseravtion',
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
                controller: persoonsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text("Nombre de personnes"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
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
                                    content: const Text('date de fin doit etre superieur au date de debut'),
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
                                  await FirebaseFirestore.instance.collection('reservations').add({
                                    'userId': user['uid'],
                                    'start': start,
                                    'end': end,
                                    'persons': int.tryParse(persoonsController.text),
                                    'centerId': widget.centerModel.id!,
                                    'status': false
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child: Text("Reserver"))),
                  )
          ],
        ),
      ),
    );
  }
}
