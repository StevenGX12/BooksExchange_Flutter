// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../Helpers/Widgets/standard_widgets.dart';
import '../Models/user.dart' as userModel;
import '../Helpers/Firebase_Services/listing_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/listing.dart';
import 'home_page.dart';

class ListingDetailsPage extends StatefulWidget {
  final String listingID;
  userModel.User? currUser;
  ListingDetailsPage({
    Key? key,
    required this.listingID,
  }) : super(key: key);
  @override
  ListingDetailsPageState createState() => ListingDetailsPageState();
}

class ListingDetailsPageState extends State<ListingDetailsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String currUserID = '';
  bool isOwnListing = false;
  List<Listing> currListUserListings = [];

  refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return const NoticeDialog(
          content: 'Not authorised. Please sign in again');
    } else {
      currUserID = auth.currentUser!.uid;
      print("Current User ID: $currUserID");
      return FutureBuilder(
          future: Future.wait([
            FirebaseServiceListingDetails().getListing(widget.listingID),
            FirebaseServiceListingDetails().getUser(currUserID),
            FirebaseServiceListingDetails().getUserCurrentListings(currUserID)
          ]),
          builder: ((context, snapshotListing) {
            if (snapshotListing.hasData) {
              Listing currListing = snapshotListing.data![0] as Listing;
              widget.currUser = snapshotListing.data![1] as userModel.User;
              currListUserListings = snapshotListing.data![2] as List<Listing>;
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Book Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255))),
                  backgroundColor: const Color.fromARGB(255, 168, 49, 85),
                ),
                body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            currListing.bookTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 7),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Author",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 51, 64, 113)),
                            )),
                        Container(
                            padding: const EdgeInsets.only(
                                left: 20, top: 5, right: 20, bottom: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              currListing.author,
                            )),
                        Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 7),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Genre",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                )),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 5, right: 20, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  currListing.genres.join("/ "),
                                )),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 7),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Synopsis",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                )),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 5, right: 20, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  currListing.synopsis,
                                )),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 7),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Time and location for exchange",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                )),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 5, right: 20, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  currListing.exchangeDetails,
                                )),

                            // Enroll button
                            const SizedBox(height: 20),
                            currListing.userID == currUserID
                                ? deleteButton()
                                : makeRequestButton(
                                    currListUserListings, currListing),
                          ],
                        ),
                      ],
                    ))),
              );
            } else if (snapshotListing.hasError) {
              return const NoticeDialog(
                  content: 'Listing not found! Please try again');
            } else {
              return const LoadingScreen();
            }
          }));
    }
  }

  Widget deleteButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          FirebaseServiceListingDetails()
              .deleteListing(widget.listingID)
              .then((message) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Deletion Status"),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        if (message == "Listing deleted successfully.") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          ).then((value) => refreshCallback());
                        }
                      },
                      child: const Text("Back to Home Page"),
                    ),
                  ],
                );
              },
            );
          });
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)))),
        child: const Text('Delete Listing'),
      ),
    );
  }

  Widget makeRequestButton(List<Listing> listings, Listing currListing) {
    String? selectedListingID; // Variable to store the selected ListingID
    bool selected = false;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          // Show dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select a book to exchange'),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text(
                                'Select one of your books to exchange'),
                            value: selectedListingID,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedListingID = newValue;
                                selected = true;
                              });
                            },
                            items: listings.map((Listing listing) {
                              return DropdownMenuItem<String>(
                                value: listing.listingID,
                                child: Text(listing.bookTitle),
                              );
                            }).toList(),
                          ),
                          selected == true
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Your logic to send request goes here
                                    FirebaseServiceListingDetails()
                                        .addExchangeRequest(
                                            currUserID,
                                            currListing.userID,
                                            selectedListingID!,
                                            currListing.listingID)
                                        .then((message) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Request Status"),
                                            content: Text(message),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the dialog
                                                  if (message ==
                                                      "Exchange request sent successfully.") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomePage()),
                                                    ).then((value) =>
                                                        refreshCallback());
                                                  }
                                                },
                                                child: const Text(
                                                    "Back to Home Page"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                  child: const Text('Send Request'),
                                )
                              : const SizedBox(height: 0),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        child: const Text('Make an exchange request'),
      ),
    );
  }
}
