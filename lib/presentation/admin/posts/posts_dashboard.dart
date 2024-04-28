import 'package:campino/Models/postModel.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class PostsDashboard extends StatefulWidget {
  const PostsDashboard({Key? key}) : super(key: key);

  @override
  State<PostsDashboard> createState() => _PostsDashboardState();
}

class _PostsDashboardState extends State<PostsDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe3eaef),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: Constants.screenHeight * 0.03, top: Constants.screenHeight * 0.1),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: Constants.screenHeight * 0.02),
                        child: Text(
                          "Liste de publications",
                          style: TextStyle(fontSize: Constants.screenHeight * 0.025),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/request.png',
                      height: Constants.screenHeight * 0.07,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("posts").where('reportingUser', isNotEqualTo: []).snapshots(),
              builder: (context, postsSnapshots) {
                if (postsSnapshots.hasData) {
                  if (postsSnapshots.data!.size != 0) {
                    return ListView.builder(
                        itemCount: postsSnapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          List<PostModel> postslists = [];
                          var listOfData = postsSnapshots.data!.docs.toList();

                          for (var center in listOfData) {
                            postslists.add(PostModel.fromJson(center.data() as Map<String, dynamic>));
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration:
                                  BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: StreamBuilder(
                                      stream:
                                          FirebaseFirestore.instance.collection("users").doc(postslists[index].owner).snapshots(),
                                      builder:
                                          (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            children: [
                                              CircleAvatar(
                                                radius: Constants.screenHeight * 0.033,
                                                backgroundColor: Colors.green,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage("${snapshot.data!.get("profileUrl")}"),
                                                  radius: Constants.screenHeight * 0.030,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("${snapshot.data!.get("userName")}"),
                                                        Padding(
                                                          padding: const EdgeInsets.all(3.0),
                                                          child: Text(
                                                            "nombre de signales :${postslists[index].reportingUser.length}",
                                                            style: TextStyle(color: Colors.red),
                                                          ),
                                                        )
                                                      ],
                                                    ),
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
                                              Spacer(),
                                              IconButton(
                                                  onPressed: () {
                                                    AlertDialog alert = AlertDialog(
                                                      title: Text("Supprimer"),
                                                      content: Text("êtes-vous sûr de vouloir supprimer cet élément?"),
                                                      actions: [
                                                        // Define the actions that the user can take
                                                        TextButton(
                                                          child: Text("Annuler"),
                                                          onPressed: () {
                                                            // Close the dialog
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            "Restaurer",
                                                            style: TextStyle(color: Colors.green),
                                                          ),
                                                          onPressed: () {
                                                            postsSnapshots.data!.docs[index].reference
                                                                .update({'reportingUser': []});
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            "Supprimer",
                                                            style: TextStyle(color: Colors.red),
                                                          ),
                                                          onPressed: () async {
                                                            postsSnapshots.data!.docs[index].reference.delete();
                                                            final snackBar = SnackBar(
                                                              content: const Text('Vous avez supprimé ce publication'),
                                                              backgroundColor: (Colors.red),
                                                              action: SnackBarAction(
                                                                label: 'fermer',
                                                                textColor: Colors.white,
                                                                onPressed: () {},
                                                              ),
                                                            );
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );

                                                    // Show the dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return alert;
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(Icons.more_vert)),
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      if (postslists[index].image!.isNotEmpty) ...[
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
                                      ],
                                    ],
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
    );
  }
}
