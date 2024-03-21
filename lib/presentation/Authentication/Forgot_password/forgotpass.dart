import 'package:campino_pfe/presentation/Authentication/Sign_up/alertTask.dart';
import 'package:campino_pfe/presentation/components/input_field/input_field.dart';
import 'package:campino_pfe/presentation/ressources/dimensions/constants.dart';
import 'package:campino_pfe/services/AuthServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Sign_in/sign_in.dart';

//import 'homescreen.dart';

final _formkey = GlobalKey<FormState>();

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  child: Stack(
                children: [
                  Column(children: [
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(90),
                        ),
                        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                          Colors.blueGrey,
                          Colors.indigo,
                        ]),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                              height: 90,
                              width: 90,
                            ),
                          ),
                          // SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              'Restaurer votre mot de passe ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  //  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      )),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formkey,
                      child: InputField(
                          label: 'Email',
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          prefixWidget: Icon(Icons.email)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    loading
                        ? CircularProgressIndicator()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Expanded(
                                    child: CupertinoButton(
                                        child:
                                            Text('Envoyer', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                                        color: Colors.indigo,
                                        onPressed: () {
                                          if (_formkey.currentState!.validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            AuthServices().resetPassword(emailController.text).then((value) {
                                              setState(() {
                                                loading = false;
                                              });
                                              if (value) {
                                                alertTask(
                                                  lottieFile: "assets/lotties/success.json",
                                                  action: "Connecter",
                                                  message: "Consultez vos mail svp",
                                                  press: () {
                                                    Get.to(() => SignInScreen());
                                                  },
                                                ).show(context);
                                              } else {
                                                alertTask(
                                                  lottieFile: "assets/lotties/error.json",
                                                  action: "Ressayer",
                                                  message: "compte n'existe pas ",
                                                  press: () {
                                                    Navigator.pop(context);
                                                  },
                                                ).show(context);
                                              }
                                            });
                                          }
                                        }))
                              ],
                            )),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: Constants.screenHeight * 0.07,
                      width: double.infinity,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(SignInScreen());
                            },
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: Constants.screenHeight * 0.06,
                          ),
                          Text(
                            "mot de passe oublié",
                            style: TextStyle(
                                fontStyle: FontStyle.italic, color: Colors.white, fontSize: Constants.screenHeight * 0.03),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )))),
    );
  }
}
