import 'package:campino/Models/Users.dart';
import 'package:campino/presentation/client/views/messages/Messenger.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Models/postModel.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user = GetStorage().read("user");
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffe3eaef),
      body: Container(
        width: double.infinity,
        height: Constants.screenHeight,
        child: Column(
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
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("users").doc("${widget.uid}").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage("${snapshot.data!.get("profileUrl")}"),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data!.get("userName")}",
                                    style: TextStyle(fontSize: Constants.screenHeight * 0.03),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "${snapshot.data!.get("email")}",
                                          style: TextStyle(fontSize: Constants.screenHeight * 0.02),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.uid != user['uid']) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration:
                                                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(Messenger(
                                                        user: Cusers(
                                                            uid: snapshot.data!.get("uid"),
                                                            userName: snapshot.data!.get("userName"),
                                                            email: snapshot.data!.get("email"),
                                                            gsm: snapshot.data!.get("gsm"),
                                                            role: snapshot.data!.get("role"),
                                                            profileUrl: snapshot.data!.get("profileUrl"))));
                                                  },
                                                  child: Image.asset('assets/images/chat.png',
                                                      height: Constants.screenHeight * 0.05),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Constants.screenWidth * 0.11,
                                            ),
                                            Container(
                                              decoration:
                                                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    final Uri launchUri = Uri(
                                                      scheme: 'tel',
                                                      path: snapshot.data!.get("gsm"),
                                                    );
                                                    await launchUrl(launchUri);
                                                  },
                                                  child: Image.asset('assets/images/call.png',
                                                      height: Constants.screenHeight * 0.05),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .orderBy("creationDate", descending: true)
                    .where("owner", isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.size != 0) {
                      return ListView.builder(
                          controller: _controller,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            List<PostModel> postslists = [];
                            var listOfData = snapshot.data!.docs.toList();

                            for (var center in listOfData) {
                              postslists.add(PostModel.fromJson(center.data() as Map<String, dynamic>));
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(postslists[index].owner)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                              if (snapshot.hasData) {
                                                return Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage("${snapshot.data!.get("profileUrl")}"),
                                                      radius: Constants.screenHeight * 0.025,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${snapshot.data!.get("userName")}"),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "${DateFormat("yyyy-MM-dd hh:mm").format(postslists[index].creationDate)}"),
                                                              Icon(
                                                                Icons.access_time_sharp,
                                                                size: Constants.screenHeight * 0.02,
                                                                color: Colors.blueAccent,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      children: [
                                                        ReadMoreText(
                                                          '${postslists[index].description}',
                                                          trimLines: 2,
                                                          style: TextStyle(color: Colors.black),
                                                          colorClickableText: Colors.pink,
                                                          trimMode: TrimMode.Line,
                                                          trimCollapsedText: '...voir plus',
                                                          trimExpandedText: ' reduire ',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (postslists[index].image != '') ...[
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Container(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Image.network(
                                                        "${postslists[index].image}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else {
                      return Center(
                        child: Container(
                          height: Constants.screenHeight * 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Pas des publications pour le moment "),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
