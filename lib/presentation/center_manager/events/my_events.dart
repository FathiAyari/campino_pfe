import 'package:campino/models/event.dart';
import 'package:campino/presentation/center_manager/events/add_event.dart';
import 'package:campino/presentation/center_manager/events/event_reservations.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  var user = GetStorage().read('user');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddEvenet());
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').where('userId', isEqualTo: user['uid']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Event> events = [];
            for (var data in snapshot.data!.docs.toList()) {
              events.add(Event.fromJson(data.data() as Map<String, dynamic>));
            }
            if (events.isEmpty) {
              return Center(
                child: Container(
                  height: Constants.screenHeight * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pas des evenements pour le moment "),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(EventsReservations(
                            event: events[index],
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
                                  "Nom d'evenement :${events[index].name}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Adresse : ${events[index].addresse}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Date de debut : ${DateFormat("yyyy/MM/dd").format(events[index].start)}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Date de fin : ${DateFormat("yyyy/MM/dd").format(events[index].end)}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Description : ${events[index].description}",
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
    );
  }
}
