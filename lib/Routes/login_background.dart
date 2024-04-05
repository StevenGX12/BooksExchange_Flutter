import 'package:flutter/material.dart';

class LoginBackgroundPage extends StatelessWidget {
  const LoginBackgroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 224, 224),
            ),
          ),
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.3,
            left: -MediaQuery.of(context).size.width * 0.3,
            right: -MediaQuery.of(context).size.width * 0.1,
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 203, 203),
              ),
            ),
          ),
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.8,
            right: -MediaQuery.of(context).size.width * 0.1,
            bottom: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    const Color.fromARGB(255, 245, 166, 166).withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
