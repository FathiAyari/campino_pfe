import 'dart:io';

import 'package:campino/models/ProductModel.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:campino/services/StoreServices.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool isLoading = false;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  Future getPostImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.blueAccent,
                          )),
                      SizedBox(
                        width: Constants.screenWidth * 0.1,
                      ),
                      Text(
                        "Ajouter une publication",
                        style: TextStyle(
                            color: Colors.blueAccent, fontStyle: FontStyle.italic, fontSize: Constants.screenWidth * 0.05),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Nom obligatoire";
                            }
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                              label: Text("Nom"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Description de produit",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description obligatoire";
                              }
                            },
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: Constants.screenWidth * 0.4,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Prix obligatoire";
                                  }
                                },
                                controller: priceController,
                                decoration: InputDecoration(
                                    label: Text("Prix en DT"),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: Constants.screenWidth * 0.9,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "adresse obligatoire";
                                  }
                                },
                                controller: adresseController,
                                decoration: InputDecoration(
                                    label: Text("Adresse"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getPostImage();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Constants.screenHeight * 0.03),
                    child: Container(
                      height: Constants.screenHeight * 0.09,
                      child: _image == null
                          ? Image.asset("assets/images/gallery.png")
                          : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() && _image != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var image = FirebaseStorage.instance.ref(_image!.path);
                                  var task = image.putFile(_image!);
                                  var imageUrl = await (await task).ref.getDownloadURL();
                                  var check = StoreServices().createProduct(Product(
                                      owner: Constants.user['uid'],
                                      name: nameController.text,
                                      ownerImage: Constants.user['profileUrl'],
                                      image: imageUrl,
                                      creationDate: DateTime.now(),
                                      description: descriptionController.text,
                                      price: double.parse(priceController.text),
                                      state: false,
                                      id: "",
                                      adresse: adresseController.text,
                                      sold: false));
                                  check.then((value) {
                                    if (value) {
                                      Fluttertoast.showToast(
                                          msg: "Demande en cours de traitement",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Get.back();
                                    }
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Image est obligatoire",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: Text("Publier"))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
