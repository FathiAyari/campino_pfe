import 'package:campino/models/center_reservation.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MyReservations extends StatefulWidget {
  const MyReservations({Key? key}) : super(key: key);

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  var user = GetStorage().read('user');
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
                  "Mes Reservations",
                  style: TextStyle(color: Colors.blueAccent, fontStyle: FontStyle.italic, fontSize: Constants.screenWidth * 0.05),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reservations').where('userId', isEqualTo: user['uid']).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CenterReservation> reservation = [];
                  for (var data in snapshot.data!.docs.toList()) {
                    reservation.add(CenterReservation.fromJson(data.data() as Map<String, dynamic>));
                  }
                  if (reservation.isEmpty) {
                    return Center(
                      child: Container(
                        height: Constants.screenHeight * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Pas des reservations pour le moment "),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: reservation.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.close,
                                    label: 'Fermer',
                                    onPressed: (BuildContext ctx) {},
                                  ),
                                  SlidableAction(
                                      onPressed: (BuildContext ctx) {
                                        snapshot.data!.docs[index].reference.delete();
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: "Supprimer"),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: reservation[index].status
                                          ? Colors.green.withOpacity(0.8)
                                          : Colors.red.withOpacity(0.8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "date debut de reservation : ${DateFormat("yyyy/MM/dd").format(reservation[index].start)}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "date fin de reservation : ${DateFormat("yyyy/MM/dd").format(reservation[index].end)}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "Nombre de persons : ${reservation[index].persons}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
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
          )
        ],
      ),
    ));
  }
}
