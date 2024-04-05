import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/exchange.dart';

class FirebaseServiceRequests {
  Future<List<Exchange>> getIncomingRequests(String userID) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('exchanges')
        .where('toUserID', isEqualTo: userID)
        .where('toUserCompleted', isEqualTo: false)
        .get();
    List<Exchange> exchangeList = querySnapshot.docs.map((doc) {
      return Exchange.fromFireStore(doc, null);
    }).toList();
    return exchangeList;
  }

  Future<List<Exchange>> getOutgoingRequests(String userID) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('exchanges')
        .where('fromUserID', isEqualTo: userID)
        .where('fromUserCompleted', isEqualTo: false)
        .get();
    List<Exchange> exchangeList = querySnapshot.docs.map((doc) {
      return Exchange.fromFireStore(doc, null);
    }).toList();
    return exchangeList;
  }

  Future<String> acceptRequest(String exchangeID, String toListingID) async {
    try {
      await FirebaseFirestore.instance
          .collection('exchanges')
          .doc(exchangeID)
          .update({
        'isAccepted': true,
      });

      await FirebaseFirestore.instance
          .collection('listings')
          .doc(toListingID)
          .update({
        'isReserved': true,
      });
      return 'Request accepted successfully.';
    } catch (error) {
      print('Error accepting request: $error');
      return 'Error accepting this request!';
    }
  }

  Future<String> declineRequest(String exchangeID, String fromListingID) async {
    try {
      await FirebaseFirestore.instance
          .collection('exchanges')
          .doc(exchangeID)
          .delete();

      await FirebaseFirestore.instance
          .collection('listings')
          .doc(fromListingID)
          .update({
        'isReserved': false,
      });
      return 'Request declined successfully.';
    } catch (error) {
      print('Error declining request: $error');
      return 'Error declining this request!';
    }
  }

  Future<String> fromCompleteRequest(
      String exchangeID, String fromListingID) async {
    try {
      await FirebaseFirestore.instance
          .collection('exchanges')
          .doc(exchangeID)
          .update({
        'fromUserCompleted': true,
      });

      await FirebaseFirestore.instance
          .collection('listings')
          .doc(fromListingID)
          .delete();
      return 'Request completed successfully.';
    } catch (error) {
      print('Error completing request: $error');
      return 'Error completing this request!';
    }
  }

  Future<String> toCompleteRequest(
      String exchangeID, String toListingID) async {
    try {
      await FirebaseFirestore.instance
          .collection('exchanges')
          .doc(exchangeID)
          .update({
        'toUserCompleted': true,
      });

      await FirebaseFirestore.instance
          .collection('listings')
          .doc(toListingID)
          .delete();
      return 'Request completed successfully.';
    } catch (error) {
      print('Error completing request: $error');
      return 'Error completing this request!';
    }
  }
}
