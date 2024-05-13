import 'package:campino/models/centerModel.dart';
import 'package:campino/presentation/center_manager/centers/center_reservations.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CenterDetailsManager extends StatefulWidget {
  final CenterModel center;
  const CenterDetailsManager({Key? key, required this.center}) : super(key: key);

  @override
  State<CenterDetailsManager> createState() => _CenterDetailsManagerState();
}

class _CenterDetailsManagerState extends State<CenterDetailsManager> {
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
          '${widget.center.name}',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('centers').doc(widget.center.id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            CenterModel centerModel = CenterModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            return SingleChildScrollView(
              child: Container(
                height: Constants.screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(MyCenterReservations(
                                  id: widget.center.id!,
                                ));
                              },
                              child: Text("Les reservations"))),
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
                              'Addresse de centre : ${centerModel.adresse}',
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
                            child: Container(
                              height: Constants.screenHeight * 0.5,
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
                ),
              ),
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
