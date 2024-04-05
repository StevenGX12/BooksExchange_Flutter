//This file stores classes that represent the major objects used
//These classes will be used to store the data returned from backend
import 'package:cloud_firestore/cloud_firestore.dart';

//Post class for user posts
class Listing {
  final String listingID;
  final String userID;
  final String bookTitle;
  final String author;
  final List<String> genres;
  final String synopsis;
  final String exchangeDetails;
  final bool isReserved;

//use of required keyword as none of these fields can be null
  Listing({
    required this.listingID,
    required this.userID,
    required this.bookTitle,
    required this.author,
    required this.genres,
    required this.synopsis,
    required this.exchangeDetails,
    required this.isReserved,
  }); // to do: close enrollment upon reaching maxAttendees

  factory Listing.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final listing = snapshot.data();
    return Listing(
      listingID: snapshot.id,
      userID: listing?['userID'] == null ? '' : listing?['userID'] as String,
      bookTitle:
          listing?['bookTitle'] == null ? '' : listing?['bookTitle'] as String,
      author: listing?['author'] == null ? '' : listing?['author'] as String,
      genres: listing?['genres'] is Iterable
          ? List<String>.from(listing?['genres'])
          : [],
      synopsis:
          listing?['synopsis'] == null ? '' : listing?['synopsis'] as String,
      exchangeDetails: listing?['exchangeDetails'] == null
          ? ''
          : listing?['exchangeDetails'] as String,
      isReserved: listing?['isReserved'] == null
          ? false
          : listing?['isReserved'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'bookTitle': bookTitle,
      'author': author,
      'genres': genres,
      'synopsis': synopsis,
      'exchangeDetails': exchangeDetails,
      'isReserved': isReserved,
    };
  }
}
