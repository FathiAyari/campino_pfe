import 'package:campino/models/evenet_reservation.dart';
import 'package:campino/models/event.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MyEvenetsReservations extends StatefulWidget {
  const MyEvenetsReservations({Key? key}) : super(key: key);

  @override
  State<MyEvenetsReservations> createState() => _MyEvenetsState();
}

class _MyEvenetsState extends State<MyEvenetsReservations> {
  var user = GetStorage().read('user');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.indigo, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Mes evenements',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('eventReservation').where('userId', isEqualTo: user['uid']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<EventReservation> events = [];
            for (var data in snapshot.data!.docs.toList()) {
              events.add(EventReservation.fromJson(data.data() as Map<String, dynamic>));
            }
            print(snapshot.data!.docs.toList());
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
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.close,
                              label: 'Fermer',
                              onPressed: (BuildContext ctx) {},
                            ),
                            SlidableAction(
                                onPressed: (BuildContext ctx) async {
                                  snapshot.data!.docs[index].reference.delete();
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.done,
                                label: "Supprimer"),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: events[index].status ? Colors.green : Colors.red.withOpacity(0.8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('events').doc(events[index].eventId).snapshots(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                    if (snapshot.hasData) {
                                      Event ev = Event.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nom d'evenement :${ev.name}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Adresse : ${ev.addresse}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Date de debut : ${DateFormat("yyyy/MM/dd").format(ev.start)}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Date de fin : ${DateFormat("yyyy/MM/dd").format(ev.end)}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Description : ${ev.description}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
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
    ));
  }
}
