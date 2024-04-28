import 'package:campino/models/basket.dart';
import 'package:campino/presentation/client/views/market_place/product_details.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../../Models/ProductModel.dart';

class BasketWidget extends StatefulWidget {
  const BasketWidget({Key? key}) : super(key: key);

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<BasketWidget> {
  var user = GetStorage().read('user');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xffe3eaef),
            body: Column(
              children: [
                back_button(Colors.blueAccent, "Panier"),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(user['uid']).collection('basket').snapshots(),
                  builder: (context, basketSnapshot) {
                    if (basketSnapshot.hasData) {
                      if (basketSnapshot.data!.size != 0) {
                        List<Basket> basket = [];
                        for (var data in basketSnapshot.data!.docs.toList()) {
                          basket.add(Basket.fromJson(data.data() as Map<String, dynamic>));
                        }
                        return ListView.builder(
                            itemCount: basket.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('marketplace')
                                      .doc(basketSnapshot.data!.docs[index].get('productId'))
                                      .snapshots(),
                                  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> productSnapshot) {
                                    if (productSnapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            //get product to navigate
                                            Get.to(ProductDetails(
                                                product: Product.fromJson(productSnapshot.data!.data() as Map<String, dynamic>)));
                                          },
                                          child: Container(
                                            decoration:
                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                            height: Constants.screenHeight * 0.2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                    "${productSnapshot.data!.get('image')}",
                                                    fit: BoxFit.cover,
                                                    height: Constants.screenHeight * 0.15,
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Date d'ajout : ${DateFormat("yyyy/mm/dd hh:mm").format(basket[index].time)}",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            "Nom : ${productSnapshot.data!.get('name')}",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            "Adresse : ${productSnapshot.data!.get('adresse')}",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                            "Prix : ${productSnapshot.data!.get('price')}",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
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
                                                              child: Text("Oui"),
                                                              onPressed: () {
                                                                basketSnapshot.data!.docs[index].reference.delete();
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
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  });
                            });
                      } else {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/message.png',
                                height: Constants.screenHeight * 0.1,
                              ),
                              Text("Pas des elements encore.")
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
              ],
            )));
  }
}
