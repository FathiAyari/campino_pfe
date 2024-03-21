import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:campino_pfe/presentation/ressources/dimensions/constants.dart';
import 'package:campino_pfe/services/AuthServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AdmineHomeView extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<AdmineHomeView> {
  int currentIndex = 0;

  List<Widget> screens = [
    Container(),
    Container(),
    Container(),
  ];
  List<BottomNavyBarItem> items = [
    BottomNavyBarItem(inactiveColor: Colors.redAccent, icon: Icon(Icons.shopping_cart), title: Text("Marché")),
    BottomNavyBarItem(inactiveColor: Colors.green.withOpacity(0.5), icon: Icon(Icons.message), title: Text("Messages")),
    BottomNavyBarItem(inactiveColor: Colors.amber, icon: Icon(Icons.settings), title: Text("Publications")),
  ];
  Widget positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: Text(
            "Oui",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget negative() {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Non",
          style: TextStyle(color: Colors.blueAccent),
        ));
  }

  Future<bool> avoidRteurnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Vous etes sure de sortir"),
            actions: [
              negative(),
              positive(),
            ],
          );
        });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidRteurnButton,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xffe3eaef),
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(
                        Icons.list,
                        color: Colors.indigo,
                      ),
                    );
                  },
                )),
            drawer: buildDrawer(context),
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: Color(0xffe3eaef),
              onItemSelected: (int value) {
                setState(() {
                  currentIndex = value;
                });
              },
              selectedIndex: currentIndex,
              items: items,
            ),
            body: screens[currentIndex]),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    var user = GetStorage().read("user");
    return Drawer(
      elevation: 36.0,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffe3eaef),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: Constants.screenHeight,
              child: ListView(padding: EdgeInsets.zero, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: Constants.screenHeight * 0.1,
                    backgroundImage: NetworkImage("${user['profileUrl']}"),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      "${user['userName']}",
                      style: TextStyle(color: Colors.blueAccent),
                    )),
                ListTile(
                  title: const Text(
                    'Parametrage de profil',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  trailing: Icon(Icons.settings, color: Colors.blueAccent),
                  onTap: () {
                    Navigator.pop(context);

                    //  Get.to(EditProfile());
                  },
                ),
                ListTile(
                  title: const Text(
                    'Deconnecter',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  trailing: Icon(Icons.logout, color: Colors.blueAccent),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Êtes-vous sure de déconnecter ?"),
                            actions: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Non"))),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blueAccent,
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        AuthServices().logOut(context);
                                      },
                                      child: Text(
                                        "Oui",
                                        style: TextStyle(color: Colors.white),
                                      ))),
                            ],
                          );
                        });
                  },
                ),
              ]),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: Colors.blueAccent))
          ],
        ),
      ),
    );
  }
}
