import 'package:campino/presentation/components/input_field/input_field.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:campino/services/AuthServices.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangePassword> {
  bool loading = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
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
          'Changer  votre mot de passe',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            InputField(
                prefixWidget: Icon(
                  Icons.lock,
                  color: Colors.indigo,
                ),
                label: 'Nouveau mot de passe',
                textInputType: TextInputType.visiblePassword,
                controller: newPasswordController),
            InputField(
              label: "Mot de passe actuelle",
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              prefixWidget: Icon(
                Icons.lock,
                color: Colors.indigo,
              ),
            ),
            loading
                ? CircularProgressIndicator()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.001, horizontal: Constants.screenWidth * 0.07),
                    child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                AuthServices().changePassword(passwordController.text, newPasswordController.text).then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                  if (value) {
                                    final snackBar = SnackBar(
                                      content: const Text('Vous avez changé votre mot de passe'),
                                      backgroundColor: (Colors.green),
                                      action: SnackBarAction(
                                        label: 'fermer',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text('mot de passe incorrecte'),
                                      backgroundColor: (Colors.red),
                                      action: SnackBarAction(
                                        label: 'fermer',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });
                              }
                            },
                            child: Text("Changer"))),
                  )
          ],
        ),
      ),
    );
  }
}
