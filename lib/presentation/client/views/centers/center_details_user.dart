import 'package:campino/Models/Users.dart';
import 'package:campino/models/centerModel.dart';
import 'package:campino/presentation/client/views/centers/make_reservation.dart';
import 'package:campino/presentation/client/views/messages/Messenger.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CenterDetailsUser extends StatefulWidget {
  final String centerId;
  const CenterDetailsUser({Key? key, required this.centerId}) : super(key: key);

  @override
  State<CenterDetailsUser> createState() => _CenterDetailsUserState();
}

class _CenterDetailsUserState extends State<CenterDetailsUser> {
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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('centers').doc(widget.centerId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            CenterModel centerModel = CenterModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(Makereservation(
                              centerModel: centerModel,
                            ));
                          },
                          child: Text("Reserver"))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            var userHere = await FirebaseFirestore.instance.collection('users').doc(centerModel.ownerId).get();
                            Cusers userToContact = Cusers.fromJson(userHere.data() as Map<String, dynamic>);
                            Get.to(Messenger(user: userToContact));
                          },
                          child: Text("Contacter gestionnaire"))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.indigo),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Nom de centre : ${centerModel.name}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.indigo),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'GSM de centre : ${centerModel.Gsm}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.indigo),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Addresse de centre : ${centerModel.Gsm}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.indigo),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Date de  de creation : ${DateFormat('yyyy/MM/dd').format(centerModel.creationDate)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.indigo),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description de  de creation : ${centerModel.description}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                centerModel.images.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Pas des images pour le moment "),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: centerModel.images.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.blueGrey,
                              child: Image.network(
                                centerModel.images[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ))
              ],
            );
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
