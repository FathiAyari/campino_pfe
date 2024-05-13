import 'package:campino/presentation/client/views/market_place/add_item.dart';
import 'package:campino/presentation/client/views/market_place/product_details.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../Models/ProductModel.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe3eaef),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("marketplace").where("state", isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length != 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext ctx, index) {
                              List<Product> productsList = [];
                              var listOfData = snapshot.data!.docs.toList();

                              for (var center in listOfData) {
                                productsList.add(Product.fromJson(center.data() as Map<String, dynamic>));
                              }
                              return InkWell(
                                onTap: () {
                                  Get.to(ProductDetails(product: productsList[index]));
                                },
                                child: Container(
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                child: Hero(
                                              tag: "${productsList[index].id}",
                                              child: Image.network(
                                                "${productsList[index].image}",
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      child: Text(
                                                        "${productsList[index].name}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5, top: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "${productsList[index].price} DT",
                                                      style: TextStyle(fontSize: 17),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(color: Color(0xfff7f5f6), borderRadius: BorderRadius.circular(15)),
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
                                child: Text("Pas des produits à vendre pour le moment "),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddItem());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
