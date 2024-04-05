import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/listing.dart';
import '../../Models/user.dart';

class FirebaseServiceListing {
  Future<List<Listing>> getOthersListings(String userid) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('listings')
        .where('isReserved', isEqualTo: false)
        .where('userID', isNotEqualTo: userid)
        .get();
    List<Listing> listingList = querySnapshot.docs.map((doc) {
      return Listing.fromFireStore(doc, null);
    }).toList();
    return listingList;
  }

  Future<List<Listing>> getListingsByUser(String userid) async {
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

  Future<User> getUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    User currUser = User.fromFireStore(querySnapshot, null);
    return currUser;
  }

  void createListing(String userID, String bookTitle, String author,
      List<String?> genres, String exchangeDetails, String synopsis) {
    FirebaseFirestore.instance.collection('listings').add({
      'userID': userID,
      'bookTitle': bookTitle,
      'author': author,
      'genres': genres,
      'synopsis': synopsis,
      'exchangeDetails': exchangeDetails,
      'isReserved': false,
    });
  }
}
