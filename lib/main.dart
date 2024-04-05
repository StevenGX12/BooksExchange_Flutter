import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Routes/login.dart';
import 'firebase_options.dart';

// Initialise Firebase instance
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Entry point of this application
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(fontSize: 14),
              floatingLabelStyle: TextStyle(
                  color: Color.fromARGB(255, 71, 88, 149), fontSize: 14)),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color.fromARGB(255, 71, 88, 149))),
    );
  }
}
