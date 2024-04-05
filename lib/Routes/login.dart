import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_background.dart';
import 'signup_page.dart';
import '../Helpers/Firebase_Services/signup.dart';
import 'home_page.dart';
import '../Helpers/Authentication/auth_service.dart';
import '../Helpers/Widgets/standard_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final firebaseService = FirebaseServiceSignup();
  bool loginRequestProcessing = false;

  loginProcessingCallback() {
    setState(() {
      loginRequestProcessing = !loginRequestProcessing;
    });
  }

  Widget logo() {
    return Container(
      width: 170,
      height: 170,
      margin: const EdgeInsets.only(top: 100),
      child: Image.asset('assets/images/Logo1_nobg.png'),
    );
  }

  Widget appName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: const Text(
        'Books Exchange',
        style: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.only(right: 40, left: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email cannot be empty';
          }
          return null;
        },
        controller: emailUsernameController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your email',
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      margin: const EdgeInsets.only(right: 40, left: 40),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your password',
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
        width: 250,
        height: 36,
        child: ElevatedButton(
          onPressed: () {
            loginProcessingCallback();
            try {
              AuthService()
                  .login(
                email: emailUsernameController.text,
                password: passwordController.text,
              )
                  .then((value) {
                loginProcessingCallback();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    content: Text(
                      "Logged In Successfully",
                      style: TextStyle(
                          color: Color.fromARGB(255, 143, 62, 62),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }).whenComplete(() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ));
            } on FirebaseAuthException catch (e) {
              loginProcessingCallback();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoticeDialog(
                        content: e.code == "invalid-credential."
                            ? 'Incorrect email or password. Please try again.'
                            : 'Error. Please try again.');
                  });
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
          child: const Text(
            'Login',
            style: TextStyle(color: Color.fromARGB(255, 119, 71, 71)),
          ),
        ));
  }

  Widget signupButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Don\'t have an account?'),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage1()),
          );
        },
        child: const Text(
          'Sign up',
          style: TextStyle(color: Color.fromARGB(255, 146, 49, 49)),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const LoginBackgroundPage(),
        ListView(children: [
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //Logo up top
                  logo(),
                  //App name
                  appName(),
                  //Email field
                  emailField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Password field
                  passwordField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 20),
                  //Login button
                  loginButton(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 28),
                  //Sign up button
                  signupButton(),
                ],
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
