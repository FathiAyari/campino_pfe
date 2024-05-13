import 'package:campino/presentation/center_manager/centers/add_center.dart';
import 'package:campino/presentation/ressources/dimensions/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lt;

var centersCollection = FirebaseFirestore.instance.collection('centers');

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController centerNameController = TextEditingController();
  TextEditingController gsmNameController = TextEditingController();

  bool isLoading = false;
  bool isDone = false;
  late Uint8List markerIcon;
  late double longitude;
  late double altitude;
  getCurrentPosition() async {
    LocationPermission permission;
    // check the permission of geolocator
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {}
    } else {
      var position = await Geolocator.getCurrentPosition();

      longitude = position.longitude;
      altitude = position.altitude;
    }
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: StreamBuilder<QuerySnapshot>(
        stream: centersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var listOfCenters = snapshot.data!.docs.toList();
            Set<Marker> markers = {};
            for (var data in listOfCenters) {
              markers.add(Marker(
                  onTap: () async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(data.get("latitude"), data.get("langitude"));
                    Get.closeCurrentSnackbar();
                    Get.snackbar(
                        "Campino",
                        "Nom :${data.get("name")}\n"
                            "Adresse : ${placemarks[0].country}-${placemarks[0].administrativeArea}-${placemarks[0].name}\n GSM:${data.get("Gsm")}",
                        borderRadius: 20,
                        duration: Duration(seconds: 10),
                        icon: Icon(Icons.location_on, color: Colors.blueAccent),
                        snackPosition: SnackPosition.TOP,
                        mainButton: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Icon(Icons.close)));
                  },
                  markerId: MarkerId(data.id),
                  position: LatLng(data.get('latitude'), data.get('langitude'))));
            }
            return Container(
              child: Stack(
                children: [
                  GoogleMap(
                    markers: markers,
                    trafficEnabled: true,
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    onLongPress: (test) async {
                      List<Placemark> placemarks = await placemarkFromCoordinates(
                        test.latitude,
                        test.longitude,
                      );

                      String adresse = '${placemarks[0].administrativeArea}-${placemarks[0].name}';
                      Get.to(AddCenter(
                        latitude: test.latitude,
                        langitude: test.longitude,
                        adresse: adresse,
                      ));
                    },
                    initialCameraPosition: CameraPosition(
                      zoom: 6.7,
                      target: LatLng(36.820719, 9.776173),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }

  Column doneAddcenter(BuildContext context) {
    return Column(
      children: [
        lt.Lottie.asset("assets/lotties/success.json", height: Constants.screenHeight * 0.1, repeat: false),
        Text(
          "Vous avez ajouté un centre ",
          style: TextStyle(fontSize: Constants.screenHeight * 0.02, color: Colors.blueAccent),
        ),
        SizedBox(
          height: Constants.screenHeight * 0.08,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Sortir"),
            ))
      ],
    );
  }
}
/*                    showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  content: Container(
                                    height: Constants.screenHeight * 0.45,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01),
                                                child: Text(
                                                  " Ajouter un centre ",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Transform.translate(
                                                  offset: Offset(Constants.screenHeight * 0.05, -70),
                                                  child: Image.asset(
                                                    "assets/images/logo.png",
                                                    height: Constants.screenHeight * 0.1,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        isDone
                                            ? doneAddcenter(context)
                                            : Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                          "Adresse :${placemarks[0].administrativeArea}-${placemarks[0].name}"),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Champ obligatoire";
                                                          }
                                                        },
                                                        controller: centerNameController,
                                                        decoration: InputDecoration(
                                                            label: Text("Nom de centre"),
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Champ obligatoire";
                                                          }
                                                        },
                                                        keyboardType: TextInputType.number,
                                                        controller: gsmNameController,
                                                        decoration: InputDecoration(
                                                            label: Text("GSM de centre"),
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                                                      ),
                                                    ),
                                                    isLoading
                                                        ? CircularProgressIndicator()
                                                        : Row(
                                                            children: [
                                                              ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text("Annuler"),
                                                                  style: ElevatedButton.styleFrom(primary: Colors.redAccent)),
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  if (_formKey.currentState!.validate()) {

                                                                },
                                                                child: Text("Ajouter"),
                                                                style: ElevatedButton.styleFrom(primary: Colors.green),
                                                              ),
                                                            ],
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          )
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });*/
