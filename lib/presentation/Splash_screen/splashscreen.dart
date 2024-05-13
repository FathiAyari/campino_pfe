import 'dart:async';

import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:campino/presentation/ressources/router/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var seen = GetStorage().read("seen");
  var role = GetStorage().read("role");
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (seen == 1) {
        if (role != null) {
          if (role == 'client') {
            Get.toNamed(AppRouting.homeClient);
          } else if (role == 'admin') {
            Get.toNamed(AppRouting.homeAdmin);
          } else {
            Get.toNamed(AppRouting.homeManager);
          }
        } else {
          Get.toNamed(AppRouting.login);
        }
      } else {
        Get.toNamed(AppRouting.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                Colors.indigo,
                Colors.blueGrey,
              ]),
            ),
            child: Column(children: <Widget>[
              SizedBox(
                height: Constants.screenHeight * 0.2,
              ),
              Image(
                image: AssetImage('assets/images/logo.png'),
                height: Constants.screenHeight * 0.1,
                width: Constants.screenWidth * 0.3,
              ),
              SizedBox(
                height: Constants.screenHeight * 0.1,
              ),
              Text(
                "Bienvenue chez Campino",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(
                height: Constants.screenHeight * 0.1,
              ),
              Lottie.asset("assets/lotties/loading.json", height: Constants.screenHeight * 0.07),
            ])));
  }
}
