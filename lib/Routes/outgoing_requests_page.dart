// ignore_for_file: library_private_types_in_public_api

import 'package:books_exchange/Models/exchange.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helpers/Firebase_Services/requests_page.dart';
import '../Helpers/Firebase_Services/listing_details_page.dart';
import '../Helpers/Widgets/standard_widgets.dart';
import '../Models/listing.dart';

class OutgoingRequestsPage extends StatefulWidget {
  final String currentUserId;

  const OutgoingRequestsPage({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _OutgoingRequestsPageState createState() => _OutgoingRequestsPageState();
}

class _OutgoingRequestsPageState extends State<OutgoingRequestsPage> {
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
            'Outgoing Requests',
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
              .getOutgoingRequests(widget.currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Exchange> outgoingRequests = snapshot.data as List<Exchange>;
              return ListView.builder(
                itemCount: outgoingRequests.length,
                itemBuilder: (context, index) {
                  Exchange request = outgoingRequests[index];
                  return InkWell(
                    onTap: () async {
                      FirebaseServiceListingDetails()
                          .getListing(request.toListingID)
                          .then((value) => showDialog(
                                context: context,
                                builder: (context) =>
                                    exchangeDetailsPopUp(value),
                              ));
                    },
                    child: Container(
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
                                const Text('in exchange for their'),
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
                              : const SizedBox(),
                        ],
                      ),
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

  Widget exchangeDetailsPopUp(Listing listing) {
    return AlertDialog(
      title: const Text('Exchange Details'),
      content: Text(listing.exchangeDetails),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget completeButton(Exchange request) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: () async {
        FirebaseServiceRequests()
            .fromCompleteRequest(request.exchangeID, request.fromListingID)
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
