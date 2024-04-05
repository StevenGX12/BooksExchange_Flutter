//This file stores classes that represent the major objects used
//These classes will be used to store the data returned from backend
import 'package:cloud_firestore/cloud_firestore.dart';

//Post class for user posts
class Exchange {
  final String exchangeID;
  final String fromUserID;
  final String toUserID;
  final String fromListingID;
  final String toListingID;
  final bool isAccepted;
  final bool fromUserCompleted;
  final bool toUserCompleted;
  final bool isCompleted;

//use of required keyword as none of these fields can be null
  Exchange(
      {required this.exchangeID,
      required this.fromUserID,
      required this.toUserID,
      required this.fromListingID,
      required this.toListingID,
      required this.isAccepted,
      required this.fromUserCompleted,
      required this.toUserCompleted,
      required this.isCompleted});

  factory Exchange.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final exchange = snapshot.data();
    return Exchange(
      exchangeID: snapshot.id,
      fromUserID: exchange?['fromUserID'] == null
          ? ''
          : exchange?['fromUserID'] as String,
      toUserID:
          exchange?['toUserID'] == null ? '' : exchange?['toUserID'] as String,
      fromListingID: exchange?['fromListingID'] == null
          ? ''
          : exchange?['fromListingID'] as String,
      toListingID: exchange?['toListingID'] == null
          ? ''
          : exchange?['toListingID'] as String,
      isAccepted: exchange?['isAccepted'] == null
          ? false
          : exchange?['isAccepted'] as bool,
      fromUserCompleted: exchange?['fromUserCompleted'] == null
          ? false
          : exchange?['fromUserCompleted'] as bool,
      toUserCompleted: exchange?['toUserCompleted'] == null
          ? false
          : exchange?['toUserCompleted'] as bool,
      isCompleted: exchange?['isCompleted'] == null
          ? false
          : exchange?['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fromUserID': fromUserID,
      'toUserID': toUserID,
      'fromListingID': fromListingID,
      'toListingID': toListingID,
      'isAccepted': isAccepted,
      'fromUserCompleted': fromUserCompleted,
      'toUserCompleted': toUserCompleted,
      'isCompleted': isCompleted,
    };
  }
}
