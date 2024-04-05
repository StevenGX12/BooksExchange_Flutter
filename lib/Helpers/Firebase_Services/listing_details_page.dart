import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/listing.dart';
import '../../Models/user.dart';

class FirebaseServiceListingDetails {
  Future<Listing> getListing(String listingID) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('listings')
            .doc(listingID)
            .get();
    Listing currListing = Listing.fromFireStore(querySnapshot, null);
    return currListing;
  }

  Future<User> getUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    User currUser = User.fromFireStore(querySnapshot, null);
    return currUser;
  }

  Future<String> deleteListing(String listingID) async {
    try {
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingID)
          .delete();
      return 'Listing deleted successfully.';
    } catch (error) {
      print('Error deleting listing: $error');
      return 'Error deleting this listing!';
    }
  }

  Future<String> addExchangeRequest(String fromUserID, String toUserID,
      String fromListingID, String toListingID) async {
    try {
      await FirebaseFirestore.instance.collection('exchanges').add({
        'fromUserID': fromUserID,
        'toUserID': toUserID,
        'fromListingID': fromListingID,
        'toListingID': toListingID,
        'isAccepted': false,
        'fromUserCompleted': false,
        'toUserCompleted': false,
        'isCompleted': false,
      });

      await FirebaseFirestore.instance
          .collection('listings')
          .doc(fromListingID)
          .update({
        'isReserved': true,
      });

      return 'Exchange request sent successfully.';
    } catch (error) {
      print('Error sending exchange request: $error');
      return 'Error sending exchange request!';
    }
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
