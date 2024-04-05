import 'package:flutter/material.dart';
import 'incoming_requests_page.dart'; // Import the IncomingRequestsPage
import 'outgoing_requests_page.dart'; // Import the OutgoingRequestsPage

class RequestsPage extends StatelessWidget {
  final String userId;

  RequestsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        centerTitle: true,
        title: const Text('View Your Requests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color.fromARGB(255, 168, 49, 85),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        IncomingRequestsPage(currentUserId: userId),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 168, 49, 85)),
              ),
              label: const Text(
                'Incoming Requests',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OutgoingRequestsPage(currentUserId: userId),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 168, 49, 85)),
              ),
              label: const Text(
                'Outgoing Requests',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
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
}
