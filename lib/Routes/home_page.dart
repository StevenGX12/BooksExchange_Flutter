import 'package:books_exchange/Routes/listing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helpers/Widgets/standard_widgets.dart';
import '../Helpers/Firebase_Services/home.dart';
import '../Helpers/Authentication/auth_service.dart';
import '../Models/listing.dart';
import 'listing_details_page.dart';
import 'listing_form.dart';
import 'requests_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final firebaseService = FirebaseServiceHome();
  FirebaseAuth auth = FirebaseAuth.instance;
  String currUserID = '';
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return const NoticeDialog(
          content: 'Not authorised. Please sign in again');
    } else {
      print("Current userid:${auth.currentUser!.uid}");
      currUserID = auth.currentUser!.uid;
      return FutureBuilder(
          future: firebaseService.getUser(auth.currentUser!.uid),
          builder: ((context, snapshotUser) {
            if (snapshotUser.hasData) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  // new changes
                  backgroundColor: const Color.fromARGB(255, 168, 49, 85),
                  title: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 3.8),
                        const Text(
                          'Home Page',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  actions: [logoutButton(context)],
                ),
                body: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/pastel.jpg'),
                                      fit: BoxFit.fill)),
                              height:
                                  MediaQuery.of(context).size.height * 1 / 3,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              18),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        1 /
                                        6,
                                    child: Image.asset(
                                        'assets/images/Logo1_nobg.png'),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              36),
                                  Wrap(children: [
                                    Text(
                                      snapshotUser.data!.username,
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ]),
                                ],
                              )),
                          const SizedBox(height: 10),
                          Stack(alignment: Alignment.center, children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: addNewListingButton(
                                  currUserID, refreshCallback),
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Your Listings',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 156, 48, 80)),
                              ),
                            )
                          ]),
                          FutureBuilder(
                              future: firebaseService.getUserCurrentListings(
                                  auth.currentUser!.uid),
                              builder: ((context, snapshotListings) {
                                if (snapshotUser.hasData) {
                                  return listingScreen(context,
                                      snapshotListings.data!, refreshCallback);
                                } else {
                                  return const LoadingComment();
                                }
                              }))
                        ])),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      homePageButton(refreshCallback),
                      listingPageButton(refreshCallback),
                      requestsPageButton(refreshCallback, currUserID),
                    ],
                  ),
                ),
              );
            } else if (snapshotUser.hasError) {
              print(snapshotUser.error);
              return const NoticeDialog(
                  content: 'User not found! Please try again');
            } else {
              return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: const Text('Home Page',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    backgroundColor: const Color.fromARGB(255, 168, 49, 85),
                  ),
                  body: const LoadingScreen());
            }
          }));
    }
  }

  Widget homePageButton(Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.home, color: Color.fromARGB(255, 168, 49, 85)),
      onPressed: () {
        refreshCallback();
      },
    );
  }

  Widget listingPageButton(Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.book_outlined),
      color: const Color.fromARGB(255, 168, 49, 85),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListingPage()),
        ).then((value) => refreshCallback());
      },
    );
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

  Widget addNewListingButton(String userID, Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.add_box,
          color: Color.fromARGB(255, 156, 48, 80), size: 40),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListingForm(userID: userID)),
        ).then((value) => refreshCallback());
      },
    );
  }

  refreshCallback() {
    setState(() {});
  }
}

Widget logoutButton(BuildContext context) {
  return IconButton(
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      onPressed: () {
        AuthService().logout(context);
      });
}
