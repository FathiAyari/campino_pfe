import 'package:campino/presentation/client/views/centers/center_details_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var centersCollection = FirebaseFirestore.instance.collection('centers');

class UserMapScreen extends StatefulWidget {
  const UserMapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<UserMapScreen> {
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
                    Get.to(CenterDetailsUser(
                      centerId: data.get("id"),
                    ));
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
                    initialCameraPosition: CameraPosition(
                      zoom: 6.7,
                      target: LatLng(36.820719, 9.776173),
                    ),
                  ),
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
}
