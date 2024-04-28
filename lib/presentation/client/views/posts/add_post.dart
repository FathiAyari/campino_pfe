import 'dart:io';

import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:campino/services/PostServices.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/postModel.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLoading = false;

  TextEditingController subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var user = GetStorage().read("user");
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
                    style:
                        TextStyle(color: Colors.blueAccent, fontStyle: FontStyle.italic, fontSize: Constants.screenWidth * 0.05),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Sujet de publication",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                  child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champ obligatoire";
                  }
                },
                controller: subjectController,
                maxLines: 5,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              )),
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
            Expanded(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (!_image.isNull) {
                                        var image = FirebaseStorage.instance.ref(_image!.path);
                                        var task = image.putFile(_image!);
                                        var imageUrl = await (await task).ref.getDownloadURL();
                                        var check = PostServices().createPost(PostModel(
                                            owner: user['uid'],
                                            ownerImage: user['profileUrl'],
                                            image: imageUrl,
                                            likes: [],
                                            reportingUser: [],
                                            creationDate: DateTime.now(),
                                            description: subjectController.text));
                                        check.then((value) {
                                          if (value) {
                                            Fluttertoast.showToast(
                                                msg: "Votre publication a été publieé avec succès",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        });
                                      } else {
                                        var check = PostServices().createPost(PostModel(
                                            owner: user['uid'],
                                            ownerImage: user['profileUrl'],
                                            image: '',
                                            reportingUser: [],
                                            creationDate: DateTime.now(),
                                            description: subjectController.text,
                                            likes: []));
                                        check.then((value) {
                                          if (value) {
                                            Fluttertoast.showToast(
                                                msg: "Votre publication a été publieé avec succès",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        });
                                      }

                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text("Publier"))),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
