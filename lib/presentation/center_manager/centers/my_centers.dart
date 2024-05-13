import 'package:campino/models/centerModel.dart';
import 'package:campino/presentation/center_manager/centers/center_details.dart';
import 'package:campino/presentation/center_manager/centers/map.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MyCenters extends StatefulWidget {
  const MyCenters({Key? key}) : super(key: key);

  @override
  State<MyCenters> createState() => _MyCentersState();
}

class _MyCentersState extends State<MyCenters> {
  var user = GetStorage().read('user');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('centers').where('ownerId', isEqualTo: user['uid']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CenterModel> centers = [];
            for (var data in snapshot.data!.docs.toList()) {
              centers.add(CenterModel.fromJson(data.data() as Map<String, dynamic>));
            }
            if (centers.isEmpty) {
              return Center(
                child: Container(
                  height: Constants.screenHeight * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pas des centres pour le moment "),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: centers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(CenterDetailsManager(
                            center: centers[index],
                          ));
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.indigo.withOpacity(0.8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nom de centre :${centers[index].name}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "latitude : ${centers[index].latitude}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "langitude : ${centers[index].langitude}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "adresse : ${centers[index].adresse}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Description de centre : ${DateFormat("yyyy/MM/dd").format(centers[index].creationDate)}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(MapScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
