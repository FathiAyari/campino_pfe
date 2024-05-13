import 'package:campino/models/centerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddCenter extends StatefulWidget {
  final double latitude;
  final String adresse;
  final double langitude;
  const AddCenter({Key? key, required this.langitude, required this.latitude, required this.adresse}) : super(key: key);

  @override
  State<AddCenter> createState() => _AddcenterState();
}

class _AddcenterState extends State<AddCenter> {
  TextEditingController nameController = TextEditingController();
  TextEditingController gsmController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
          'Ajouter un centre',
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
              child: Text("Adresse :${widget.adresse}"),
            ),
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
                    label: Text("Nom de centre"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
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
                controller: gsmController,
                decoration: InputDecoration(
                    label: Text("GSM de centre"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
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
                    label: Text("Description de centre"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
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
                                setState(() {
                                  loading = true;
                                });
                                var centersCollection = FirebaseFirestore.instance.collection("centers");
                                var doc = centersCollection.doc();
                                await centersCollection.doc(doc.id).set(CenterModel(
                                      ownerId: user['uid'],
                                      creationDate: DateTime.now(),
                                      images: [],
                                      description: descriptionController.text,
                                      name: nameController.text,
                                      latitude: widget.latitude,
                                      langitude: widget.langitude,
                                      Gsm: gsmController.text,
                                      adresse: widget.adresse,
                                    ).Tojson(doc.id));

                                setState(() {
                                  loading = false;
                                });
                                nameController.clear();
                                gsmController.clear();
                                descriptionController.clear();
                              }
                            },
                            child: Text("ajouter"))),
                  )
          ],
        ),
      ),
    );
  }
}
