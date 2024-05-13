import 'package:campino/Models/Users.dart';
import 'package:campino/models/event.dart';
import 'package:campino/presentation/client/views/messages/Messenger.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AllEvenets extends StatefulWidget {
  const AllEvenets({Key? key}) : super(key: key);

  @override
  State<AllEvenets> createState() => _AllEvenetsState();
}

class _AllEvenetsState extends State<AllEvenets> {
  var user = GetStorage().read('user');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
                      Text(
                        "Les evenements",
                        style: TextStyle(
                            color: Colors.blueAccent, fontStyle: FontStyle.italic, fontSize: Constants.screenWidth * 0.05),
                      )
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Event> events = [];
                      for (var data in snapshot.data!.docs.toList()) {
                        events.add(Event.fromJson(data.data() as Map<String, dynamic>));
                      }
                      print(events);
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
                        return Expanded(
                          child: ListView.builder(
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
                                              var myReservations = await FirebaseFirestore.instance
                                                  .collection('eventReservation')
                                                  .where("userId", isEqualTo: user['uid'])
                                                  .get();
                                              bool found = false;
                                              for (var data in myReservations.docs.toList()) {
                                                if (events[index].id == data.get('eventId')) {
                                                  found = true;
                                                }
                                              }
                                              if (found) {
                                                final snackBar = SnackBar(
                                                  content: const Text('Vous avez deja envoyer une demande'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'fermer',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              } else {
                                                FirebaseFirestore.instance.collection('eventReservation').add({
                                                  'userId': user['uid'],
                                                  'eventId': events[index].id,
                                                  'status': false,
                                                });
                                              }
                                            },
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            icon: Icons.done,
                                            label: "Reserver"),
                                      ],
                                    ),
                                    endActionPane: ActionPane(
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
                                              var userHere = await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(events[index].userId)
                                                  .get();
                                              Cusers userToContact = Cusers.fromJson(userHere.data() as Map<String, dynamic>);
                                              Get.to(Messenger(user: userToContact));
                                            },
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            icon: Icons.message_rounded,
                                            label: "Message"),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5), color: Colors.indigo.withOpacity(0.8)),
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
                                  ),
                                );
                              }),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
