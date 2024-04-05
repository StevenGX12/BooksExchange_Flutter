import 'package:books_exchange/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/listing.dart';

//class which stores the functions responsible for Firebase backend communication
class FirebaseServiceHome {
  Future<User> getUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    User currUser = User.fromFireStore(querySnapshot, null);
    return currUser;
  }

  Future<List<Listing>> getUserCurrentListings(String userid) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('listings')
        .where('isReserved', isEqualTo: false)
        .where('userID', isEqualTo: userid)
        .get();
    List<Listing> listingList = querySnapshot.docs.map((doc) {
      return Listing.fromFireStore(doc, null);
    }).toList();
    return listingList;
  }
}
