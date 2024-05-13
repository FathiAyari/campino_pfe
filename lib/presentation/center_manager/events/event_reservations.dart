import 'package:campino/Models/Users.dart';
import 'package:campino/models/evenet_reservation.dart';
import 'package:campino/models/event.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

class EventsReservations extends StatefulWidget {
  final Event event;
  const EventsReservations({Key? key, required this.event}) : super(key: key);

  @override
  State<EventsReservations> createState() => _EventsReservationsState();
}

class _EventsReservationsState extends State<EventsReservations> {
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
          "Reseravtion d'evenement ${widget.event.name}",
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('eventReservation').where('eventId', isEqualTo: widget.event.id).snapshots(),
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
                        child: Text("Pas de reservations pour le moment "),
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
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.done,
                              label: 'Accepter',
                              onPressed: (BuildContext ctx) {
                                snapshot.data!.docs[index].reference.update({'status': true});
                              },
                            ),
                            SlidableAction(
                                onPressed: (BuildContext ctx) async {
                                  snapshot.data!.docs[index].reference.delete();
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: "Refuser"),
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
                                  stream: FirebaseFirestore.instance.collection('users').doc(events[index].userId).snapshots(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                    if (snapshot.hasData) {
                                      Cusers ev = Cusers.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                      return Text(
                                        "Nom de client :${ev.userName}",
                                        style: TextStyle(color: Colors.white),
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
    );
  }
}
