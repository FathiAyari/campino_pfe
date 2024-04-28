import 'package:campino/Models/postModel.dart';
import 'package:campino/presentation/client/views/posts/comments.dart';
import 'package:campino/presentation/client/views/profile/profileScreen.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

import 'add_post.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  ScrollController _controller = ScrollController();
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe3eaef),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("${user['profileUrl']}"),
                          radius: Constants.screenHeight * 0.025,
                        ),
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Get.to(AddPost());
                        },
                        child: Container(
                          height: Constants.screenHeight * 0.06,
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Ajouter une publication",
                                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("posts").orderBy("creationDate", descending: true).snapshots(),
                builder: (context, postsSnapshots) {
                  if (postsSnapshots.hasData) {
                    if (postsSnapshots.data!.size != 0) {
                      return RawScrollbar(
                        thumbColor: Colors.blueAccent,
                        controller: _controller,
                        thumbVisibility: true,
                        radius: Radius.circular(20),
                        child: ListView.builder(
                            controller: _controller,
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
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(postslists[index].owner)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                            if (snapshot.hasData) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(ProfileScreen(
                                                    uid: snapshot.data!.id,
                                                  ));
                                                },
                                                child: Row(
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
                                                          Text("${snapshot.data!.get("userName")}"),
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
                                                            title: Text("Signaler"),
                                                            content: Text("êtes-vous sûr de vouloir signaler cet élément?"),
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
                                                                child: Text("Oui"),
                                                                onPressed: () async {
                                                                  List<dynamic> reports = postslists[index].reportingUser;

                                                                  if (reports.contains(user['uid'])) {
                                                                    final snackBar = SnackBar(
                                                                      content: const Text('Vous avez deja signalé ce element'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'fermer',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  } else {
                                                                    reports.add(user['uid']);
                                                                    await FirebaseFirestore.instance
                                                                        .collection('posts')
                                                                        .doc(postsSnapshots.data!.docs[index].id)
                                                                        .update({'reportingUser': reports});
                                                                    final snackBar = SnackBar(
                                                                      content: const Text('publication  signalé   '),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'fermer',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  }

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
                                                        icon: Icon(Icons.more_vert))
                                                  ],
                                                ),
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
                                          ]
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                              child: OutlinedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                      width: 2.0,
                                                      color: postslists[index].likes.contains(user['uid'])
                                                          ? Colors.red
                                                          : Colors.grey,
                                                    ),
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    List oldData = postslists[index].likes;
                                                    if (oldData.contains(user['uid'])) {
                                                      oldData.remove(user['uid']);
                                                    } else {
                                                      oldData.add(user['uid']);
                                                    }
                                                    postsSnapshots.data!.docs[index].reference.update({'likes': oldData});
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color:
                                                        postslists[index].likes.contains(user['uid']) ? Colors.red : Colors.grey,
                                                  ),
                                                  label: Text(
                                                    '${postslists[index].likes.length}',
                                                    style: TextStyle(
                                                      color: postslists[index].likes.contains(user['uid'])
                                                          ? Colors.red
                                                          : Colors.grey,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                              child: OutlinedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  side: BorderSide(width: 2.0, color: Colors.indigo),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.to(Comments(postId: postsSnapshots.data!.docs[index].id));
                                                },
                                                icon: Icon(Icons.comment, color: Colors.indigo),
                                                label: StreamBuilder<QuerySnapshot>(
                                                  builder: (context, snapshpt) {
                                                    if (snapshpt.hasData) {
                                                      return Text("${snapshpt.data!.size}",
                                                          style: TextStyle(color: Colors.indigo));
                                                    } else {
                                                      return Text("");
                                                    }
                                                  },
                                                  stream: FirebaseFirestore.instance
                                                      .collection('posts')
                                                      .doc(postsSnapshots.data!.docs[index].id)
                                                      .collection('comments')
                                                      .snapshots(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
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
      ),
    );
  }
}
