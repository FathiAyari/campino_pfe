import 'package:campino/models/ProductModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class StoreServices {
  var user = GetStorage().read('user');
  Future<bool> createProduct(Product product) async {
    try {
      var postsCollection = FirebaseFirestore.instance.collection("marketplace").doc();
      await postsCollection.set(product.Tojson(postsCollection.id));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addItemTobasket(String productId) async {
    try {
      String uid = user['uid'];
      var basket = await FirebaseFirestore.instance.collection("users").doc(uid).collection("basket").get();
      bool exists = false;
      for (var data in basket.docs.toList()) {
        if (data.get("productId") == productId) {
          exists = true;
        }
      }
      if (exists) {
        return false;
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("basket")
            .add({"productId": productId, "time": DateTime.now()});
        return true;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
