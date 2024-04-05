import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//class which stores the functions responsible for Firebase backend communication
class FirebaseServiceSignup {
  Future<void> addUser(
      String email,
      String username,
      String password,
      String phoneNumber,
      String pfp,
      List<String> favouriteGenres,
      List<String> listings,
      List<String> incomingOffers,
      List<String> outgoingOffers) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Error: $e");
    }
    final userId = _auth.currentUser?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(userId)
        .set({
          'username': username,
          'phoneNumber': phoneNumber,
          'email': email,
          'pfp': "",
          'favouriteGenres': favouriteGenres,
          'listings': listings,
          'incomingOffers': incomingOffers,
          'outgoingOffers': outgoingOffers,
          'createdAt': DateTime.now()
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

checkBlank(String value) {
  if (value == '') {
    print('$value: true');
  } else {
    return print('$value: false');
  }
}
