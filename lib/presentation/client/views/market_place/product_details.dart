import 'package:campino/presentation/Authentication/Sign_up/alertTask.dart';
import 'package:campino/presentation/client/views/profile/profileScreen.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:campino/services/StoreServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:readmore/readmore.dart';

import '../../../../Models/ProductModel.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var user = GetStorage().read('user');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                back_button(Colors.blueAccent, ''),
                Stack(
                  children: [
                    Container(
                      height: Constants.screenHeight * 0.25,
                      width: double.infinity,
                      child: Hero(tag: "${widget.product.id}", child: Image.network("${widget.product.image}")),
                    ),
                    Container(
                      height: Constants.screenHeight - Constants.screenHeight * 0.35,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      margin: EdgeInsets.only(top: Constants.screenHeight * 0.23),
                      padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.03),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Constants.screenHeight * 0.03,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text("Nom :${widget.product.name}"),
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.09),
                                  child: Text("price : ${widget.product.price} DT"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: ReadMoreText(
                              '${widget.product.description}',
                              trimLines: 3,
                              style: TextStyle(color: Colors.black),
                              colorClickableText: Colors.blueAccent,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '...Lire plus',
                              trimExpandedText: ' Reduire',
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection("users").doc(widget.product.owner).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(ProfileScreen(
                                              uid: snapshot.data!.id,
                                            ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                                            height: Constants.screenHeight * 0.15,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: Constants.screenHeight * 0.04,
                                                    backgroundImage: NetworkImage(snapshot.data!.get("profileUrl")),
                                                  ),
                                                ),
                                                Text("${snapshot.data!.get("userName")}"),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.blueAccent,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("Disponible encore : "),
                                            Text(
                                              "${widget.product.sold ? "Non" : "Oui"}",
                                              style: TextStyle(color: widget.product.sold ? Colors.red : Colors.green),
                                            ),
                                            Icon(widget.product.sold ? Icons.clear : Icons.done,
                                                color: widget.product.sold ? Colors.red : Colors.green)
                                          ],
                                        ),
                                      ),
                                      if (user['role'] == 'client')
                                        Container(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                                              icon: Icon(Icons.add),
                                              onPressed: widget.product.sold
                                                  ? null
                                                  : () {
                                                      StoreServices().addItemTobasket(widget.product.id).then((value) {
                                                        if (value) {
                                                          alertTask(
                                                            action: "Fermer",
                                                            press: () {
                                                              Navigator.pop(context);
                                                            },
                                                            lottieFile: "assets/lotties/success.json",
                                                            message: "Votre produit a été ajouté avec succès",
                                                          ).show(context);
                                                        } else {
                                                          alertTask(
                                                            action: "Fermer",
                                                            press: () {
                                                              Navigator.pop(context);
                                                            },
                                                            lottieFile: "assets/lotties/error.json",
                                                            message: "Votre produit est déja existe dans le panier",
                                                          ).show(context);
                                                        }
                                                      });
                                                    },
                                              label: Text("Ajouter au panier")),
                                        )
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Container back_button(Color color, String label) {
  return Container(
    width: double.infinity,
    height: Constants.screenHeight * 0.08,
    child: Row(
      children: [
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: color,
            )),
        SizedBox(
          width: Constants.screenWidth * 0.2,
        ),
        Text(
          "$label",
          style: TextStyle(color: Colors.blueAccent, fontSize: Constants.screenHeight * 0.03),
        )
      ],
    ),
  );
}
