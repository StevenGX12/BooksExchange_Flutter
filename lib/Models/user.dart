import 'package:cloud_firestore/cloud_firestore.dart';

//This folder stores classes that represent the major objects used
//These classes will be used to store the data returned from backend

//User class for user profile and authentication
class User {
  final String userid;
  final String username;
  final String phoneNumber;
  final String email;
  final String pfp;
  final List<String> favouriteGenres;
  final List<String> listings;
  final List<String> incomingOffers;
  final List<String> outgoingOffers;

//use of required keyword for fields that cannot be null
  User({
    required this.userid,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.pfp,
    required this.favouriteGenres,
    required this.listings,
    required this.incomingOffers,
    required this.outgoingOffers,
  });

  factory User.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final user = snapshot.data();
    return User(
      userid: snapshot.id,
      username: user?['username'] == null ? '' : user?['username'] as String,
      phoneNumber:
          user?['phoneNumber'] == null ? '' : user?['phoneNumber'] as String,
      email: user?['email'] == null ? '' : user?['email'] as String,
      pfp: user?['pfp'] == null ? '' : user?['pfp'] as String,
      favouriteGenres: user?['favouriteGenres'] is Iterable
          ? List<String>.from(user?['favouriteGenres'])
          : [],
      listings: user?['listings'] is Iterable
          ? List<String>.from(user?['listings'])
          : [],
      incomingOffers: user?['incomingOffers'] is Iterable
          ? List<String>.from(user?['incomingOffers'])
          : [],
      outgoingOffers: user?['outgoingOffers'] is Iterable
          ? List<String>.from(user?['outgoingOffers'])
          : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'pfp': pfp,
      'favouriteGenres': favouriteGenres,
      'listings': listings,
      'incomingOffers': incomingOffers,
      'outgoingOffers': outgoingOffers,
    };
  }
}
