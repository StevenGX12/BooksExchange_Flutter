// ignore_for_file: library_private_types_in_public_api

import 'package:books_exchange/Models/exchange.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helpers/Firebase_Services/requests_page.dart';
import '../Helpers/Firebase_Services/listing_details_page.dart';
import '../Helpers/Widgets/standard_widgets.dart';
import '../Models/listing.dart';

class IncomingRequestsPage extends StatefulWidget {
  final String currentUserId;

  const IncomingRequestsPage({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _IncomingRequestsPageState createState() => _IncomingRequestsPageState();
}

class _IncomingRequestsPageState extends State<IncomingRequestsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return const NoticeDialog(
          content: 'Not authorised. Please sign in again');
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: backButton(context),
          centerTitle: true,
          title: const Text(
            'Incoming Requests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 168, 49, 85),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: FirebaseServiceRequests()
              .getIncomingRequests(widget.currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Exchange> incomingRequests = snapshot.data as List<Exchange>;
              return ListView.builder(
                itemCount: incomingRequests.length,
                itemBuilder: (context, index) {
                  Exchange request = incomingRequests[index];
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:
                                    100, // Set a fixed height for the leading widget
                                child: FutureBuilder<Listing>(
                                  future: FirebaseServiceListingDetails()
                                      .getListing(request.fromListingID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      Listing listing = snapshot.data!;
                                      return Column(
                                        children: [
                                          const Icon(Icons.book,
                                              color: Colors.black, size: 80),
                                          Text(listing.bookTitle,
                                              style: const TextStyle(
                                                  fontSize: 15)),
                                        ],
                                      ); // Display book title
                                    }
                                  },
                                ),
                              ),
                              const Text('in exchange for your'),
                              Container(
                                height: 120,
                                width:
                                    100, // Set a fixed height for the trailing widget
                                child: FutureBuilder<Listing>(
                                  future: FirebaseServiceListingDetails()
                                      .getListing(request.toListingID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      Listing listing = snapshot.data!;
                                      return Column(
                                        children: [
                                          const Icon(Icons.book,
                                              color: Colors.black, size: 80),
                                          Text(listing.bookTitle),
                                        ],
                                      ); // Display book title
                                    }
                                  },
                                ),
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              request.isAccepted ? 'Accepted' : 'Pending',
                              style: TextStyle(
                                color: request.isAccepted
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        request.isAccepted
                            ? completeButton(request)
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  acceptButton(request),
                                  declineButton(request),
                                ],
                              )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      );
    }
  }

  Widget backButton(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: IconButton(
            color: Colors.white,
            iconSize: 35,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)));
  }

  Widget acceptButton(Exchange request) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      onPressed: () async {
        FirebaseServiceRequests()
            .acceptRequest(request.exchangeID, request.toListingID)
            .then((_) {
          setState(() {});
        });
      },
      child: const Text(
        'Accept',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget declineButton(Exchange request) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      onPressed: () async {
        FirebaseServiceRequests()
            .declineRequest(request.exchangeID, request.fromListingID)
            .then((_) {
          setState(() {});
        });
      },
      child: const Text(
        'Decline',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget completeButton(Exchange request) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: () async {
        FirebaseServiceRequests()
            .toCompleteRequest(request.exchangeID, request.toListingID)
            .then((message) {
          if (message == 'Request completed successfully.') {
            setState(() {});
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Request Completed'),
                      content: const Text('Enjoy your new book!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ));
          }
        });
      },
      child: const Text(
        'Complete',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
