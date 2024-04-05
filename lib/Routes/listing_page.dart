// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Helpers/Widgets/standard_widgets.dart';
import '../Models/listing.dart';
import '../Models/user.dart' as user;
import 'listing_details_page.dart';
import 'requests_page.dart';
import 'home_page.dart';
import '../Helpers/Firebase_Services/listing_page.dart';

class ListingPage extends StatefulWidget {
  user.User? currUser;
  ListingPage({super.key});
  @override
  ListingPageState createState() => ListingPageState();
}

class ListingPageState extends State<ListingPage> {
  bool editPostRequestProcessing = false;
  bool deletePostRequestProcessing = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String currUserID = '';
  String newDescription = '';

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
            FirebaseServiceListing().getOthersListings(currUserID),
            FirebaseServiceListing().getUser(currUserID)
          ]),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              List<Listing> listings = snapshot.data![0] as List<Listing>;
              widget.currUser = snapshot.data![1] as user.User;
              return Scaffold(
                appBar: AppBar(
                  leading: backButton(),
                  centerTitle: true,
                  title: const Text('View All Listings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      )),
                  backgroundColor: const Color.fromARGB(255, 168, 49, 85),
                ),
                body: listingScreen(context, listings, refreshCallback),
                bottomNavigationBar: BottomAppBar(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Visit home page to view profile
                    homePageButton(refreshCallback),
                    //Visit camera page to post sighting
                    listingPageButton(),
                    //Visit requests page to view requests
                    requestsPageButton(refreshCallback, currUserID),
                  ],
                )),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const NoticeDialog(
                  content: 'Error fetching posts. Please try again!');
            } else {
              return const LoadingScreen();
            }
          }));
    }
  }

  Widget requestsPageButton(Function refreshCallback, String userID) {
    return IconButton(
      icon: const Icon(Icons.currency_exchange,
          color: Color.fromARGB(255, 168, 49, 85)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RequestsPage(userId: userID)),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget homePageButton(Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.home, color: Color.fromARGB(255, 168, 49, 85)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget listingPageButton() {
    return IconButton(
      icon: const Icon(Icons.book_outlined,
          color: Color.fromARGB(255, 168, 49, 85)),
      onPressed: () {
        refreshCallback();
      },
    );
  }

  Widget cardTitle(Listing listing) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 12),
        child: Stack(
          children: [
            ListTile(
              leading: const Icon(
                Icons.book,
                color: Color.fromARGB(255, 33, 53, 88),
                size: 80,
              ),
              title: Text(
                listing.bookTitle.length > 60
                    ? '${listing.bookTitle.substring(0, 60)}...'
                    : listing.bookTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 33, 53, 88),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listingScreen(
      BuildContext context, List<Listing> listings, Function refreshCallback) {
    return SingleChildScrollView(
        child: SizedBox(
            child: Column(children: [
      GridView.builder(
          itemCount: listings.length,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 7.0,
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            return listingCard(listings[index], refreshCallback);
          },
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0))
    ])));
  }

  Widget listingCard(Listing listing, Function refreshCallback) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListingDetailsPage(
                    listingID: listing.listingID,
                  )),
        );
      },
      child: Card(
          color: const Color.fromARGB(255, 253, 254, 255),
          elevation: 4.5,
          shadowColor: const Color.fromARGB(255, 113, 165, 255),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(children: [cardTitle(listing)])),
    );
  }

  Widget backButton() {
    return Container(
        alignment: Alignment.topLeft,
        child: IconButton(
            color: Colors.white,
            iconSize: 35,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)));
  }

  editPostRequestProcessingCallback() {
    setState(() {
      editPostRequestProcessing = !editPostRequestProcessing;
    });
  }

  deletePostRequestProcessingCallback() {
    setState(() {
      deletePostRequestProcessing = !deletePostRequestProcessing;
    });
  }

  changeIdCallback() {
    setState(() {});
  }
}
