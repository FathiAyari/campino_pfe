import 'dart:io';

import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AddCenterImages extends StatefulWidget {
  final String centerId;
  const AddCenterImages({Key? key, required this.centerId}) : super(key: key);

  @override
  State<AddCenterImages> createState() => _AddCenterImagesState();
}

class _AddCenterImagesState extends State<AddCenterImages> {
  List<File> _selectedImages = [];
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
          'Ajouter des images',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          try {
            final List<XFile>? selectedImages = await _picker.pickMultiImage(imageQuality: 50);
            if (selectedImages != null) {
              setState(() {
                _selectedImages = selectedImages.map((e) => File(e.path)).toList();
              });
            }
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.add),
      ),
      body: _selectedImages.isEmpty
          ? Center(
              child: Container(
                height: Constants.screenHeight * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Pas des images selectionné "),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: _selectedImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.blueGrey,
                          child: Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            List<String> imagesToInsert = [];
                            try {
                              for (int i = 0; i <= _selectedImages.length; i++) {
                                var image = FirebaseStorage.instance // instance
                                    .ref(_selectedImages[i].path); //ref=> esm de fichier fel storage
                                var task = image.putFile(_selectedImages[i]);
                                var imageUrl =
                                    await (await task) // await 1: attendre l'upload d'image dans firestorage,2await: attendre la recuperation de lien getDownloadURL
                                        .ref
                                        .getDownloadURL();

                                imagesToInsert.add(imageUrl);
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                            var myImages = await FirebaseFirestore.instance.collection('centers').doc(widget.centerId).get();
                            List<String> myRealImages = [];

                            myImages.get('images').map((e) {
                              myRealImages.add(e);
                            });
                            FirebaseFirestore.instance.collection('centers').doc(widget.centerId).update({
                              'images': [...myImages.get('images'), ...imagesToInsert]
                            });
                          },
                          child: Text("Ajouter")))
                ],
              ),
            ),
    );
  }
}
