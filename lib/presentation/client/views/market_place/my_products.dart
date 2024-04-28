import 'package:campino/presentation/client/views/market_place/product_details.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../../../Models/ProductModel.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  var user = GetStorage().read('user');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              back_button(Colors.blueAccent, "Mes produits"),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("marketplace")
                      .where("owner", isEqualTo: user['uid'])
                      .where('state', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.size != 0) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              List<Product> MyProductList = [];
                              var listOfData = snapshot.data!.docs.toList();

                              for (var product in listOfData) {
                                MyProductList.add(Product.fromJson(product.data() as Map<String, dynamic>));
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Slidable(
                                  key: const ValueKey(0),
                                  startActionPane: ActionPane(
                                    // A motion is a widget used to control how the pane animates.
                                    motion: const ScrollMotion(),

                                    // A pane can dismiss the Slidable.
                                    dismissible: DismissiblePane(onDismissed: () {}),

                                    // All actions are defined in the children parameter.
                                    children: [
                                      // A SlidableAction can have an icon and/or a label.
                                      SlidableAction(
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Annuler',
                                        onPressed: (BuildContext ctx) {},
                                      ),
                                      SlidableAction(
                                        onPressed: (BuildContext ctx) {
                                          snapshot.data!.docs[index].reference.update({'sold': true});
                                        },
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        icon: Icons.done,
                                        label: 'Vendre',
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: MyProductList[index].state ? Colors.green : Colors.red),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20)),
                                      height: Constants.screenHeight * 0.2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              "${MyProductList[index].image}",
                                              fit: BoxFit.cover,
                                              height: Constants.screenHeight * 0.15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Nom : ${MyProductList[index].name}"),
                                                  Text(
                                                    "Adresse : ${MyProductList[index].adresse}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text("Prix : ${MyProductList[index].price}"),
                                                  Text("état : ${MyProductList[index].state ? "Accepté" : "en cours"}"),
                                                  Row(
                                                    children: [
                                                      Text("Disponibilité : "),
                                                      Text(
                                                        "${MyProductList[index].sold ? "Non" : "Oui"}",
                                                        style: TextStyle(
                                                            color: MyProductList[index].sold ? Colors.red : Colors.green),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                  child: Text("vous avez aucune produit publieé"),
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
      ),
    );
  }
}
