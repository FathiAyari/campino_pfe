import 'dart:io';

import 'package:campino_pfe/presentation/Authentication/Sign_in/components/infoMessage.dart';
import 'package:campino_pfe/presentation/components/input_field/input_field.dart';
import 'package:campino_pfe/presentation/on_boarding/on_boarding_controller.dart';
import 'package:campino_pfe/presentation/ressources/dimensions/constants.dart';
import 'package:campino_pfe/presentation/ressources/router/router.dart';
import 'package:campino_pfe/services/AuthServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Forgot_password/forgotpass.dart';
import '../Sign_up/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OnBoardingController controller = OnBoardingController();

  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("vous etes sur de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Campino'),
            backgroundColor: Colors.indigo
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _formkey,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: Constants.screenHeight * 0.1),
                    child: InputField(
                      label: "Email",
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      prefixWidget: Icon(
                        Icons.email,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  InputField(
                    label: "Mot de passe",
                    controller: passwordController,
                    textInputType: TextInputType.visiblePassword,
                    prefixWidget: Icon(
                      Icons.lock,
                      color: Colors.indigo,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(ForgotPassScreen());
                      },
                      child: Text(
                        "mot de passe oublié?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black54,
                            //fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CupertinoButton(
                                      child:
                                          Text('Connexion', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                                      color: Colors.indigo,
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          AuthServices()
                                              .signIn(emailController.text, passwordController.text)
                                              .then((value) async {
                                            if (value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              AuthServices().getUserData().then((value) {
                                                AuthServices().saveUserLocally(value);
                                                if (value.role == 'client') {
                                                  Navigator.pushNamed(context, AppRouting.homeClient);
                                                } else if (value.role == 'manager') {
                                                  Get.toNamed(AppRouting.homeManager);
                                                } else {
                                                  Get.toNamed(AppRouting.homeAdmin);
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              InfoMessage(
                                                press: () {
                                                  Get.back();
                                                },
                                                lottieFile: "assets/lotties/error.json",
                                                action: "Ressayer",
                                                message: "Merci de vierfier vos données ",
                                              ).show(context);
                                            }
                                          });
                                        }
                                      }))
                            ],
                          )),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            child: Text("Besoin d'un nouveau compte?",
                                style: TextStyle(color: Colors.indigo, fontSize: 14, fontStyle: FontStyle.italic)),
                            onPressed: () {
                              Get.to(SignupScreen());
                            },
                          ))
                        ],
                      )),
                ])),
          )),
    );
  }
}
