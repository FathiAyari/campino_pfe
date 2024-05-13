import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Models/Users.dart';
import '../client/views/messages/Messenger.dart';

class ClientServices extends StatelessWidget {
  const ClientServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
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
                  "Service Clients",
                  style: TextStyle(color: Colors.blueAccent, fontStyle: FontStyle.italic, fontSize: Constants.screenWidth * 0.05),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.size != 0) {
                    List<Cusers> admins = [];
                    for (var user in snapshot.data!.docs.toList()) {
                      admins.add(Cusers.fromJson(user.data()));
                    }
                    return ListView.builder(
                        itemCount: admins.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              height: Constants.screenHeight * 0.1,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.indigo.withOpacity(0.5)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(admins[index].profileUrl),
                                      radius: 40,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        admins[index].userName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        admins[index].role,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(Messenger(
                                                user: Cusers(
                                                    uid: admins[index].uid,
                                                    userName: admins[index].userName,
                                                    email: admins[index].email,
                                                    gsm: admins[index].gsm,
                                                    role: admins[index].role,
                                                    profileUrl: admins[index].profileUrl)));
                                          },
                                          child: Image.asset('assets/images/chat.png', height: Constants.screenHeight * 0.05),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                              child: Text("Pas d'admin diponible pour le moment "),
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
    ));
  }
}
