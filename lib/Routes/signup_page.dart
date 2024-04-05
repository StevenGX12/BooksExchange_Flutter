import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import '../Routes/login.dart';
import 'login_background.dart';
import '../Helpers/Firebase_Services/signup.dart';
import '../Helpers/Authentication/auth_service.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});
  @override
  SignUpPage1State createState() => SignUpPage1State();
}

class SignUpPage1State extends State<SignUpPage1> {
  String _userName = '';
  String _userEmail = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  String _phoneNumber = '';
  final MultiSelectController _controller = MultiSelectController();
  final _formKey = GlobalKey<FormState>();
  final firebaseServiceSignup = FirebaseServiceSignup();
  bool signupRequestProcessing = false;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //arrow back button to login page
                  backButton(),
                  //Logo up top
                  logo(),
                  //App Title
                  appTitle(),
                  //Username field
                  usernameField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Email field
                  emailField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Password field
                  passwordField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Confirm password field
                  confirmPasswordField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Phone number field
                  phoneNumberField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Genre field
                  genreField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 40),
                  //Sign up button
                  signUpButton(),
                  SizedBox(height: MediaQuery.of(context).size.height * 1 / 22),
                ],
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  bool isValidUsername(String username) {
    if (username.isEmpty || username.length > 25) {
      return false;
    }
    return true;
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^[\w-]+(.[\w-]+)@[a-zA-Z0-9-]+(.[a-zA-Z0-9-]+)(.[a-zA-Z]{2,})$')
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Check if the password meets the criteria
    bool hasCapitalLetter = false;
    bool hasSpecialCharacter = false;

    for (int i = 0; i < password.length; i++) {
      var char = password[i];
      if (char == char.toUpperCase()) {
        hasCapitalLetter = true;
      }
      if (char.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacter = true;
      }
    }

    return hasCapitalLetter && hasSpecialCharacter;
  }

  signupProcessingCallback() {
    setState(() {
      signupRequestProcessing = !signupRequestProcessing;
    });
  }

  Widget signUpButton() {
    return SizedBox(
        width: 250,
        height: 36,
        child: ElevatedButton(
            onPressed: () async {
              final bool? isValid = _formKey.currentState?.validate();
              if (isValid == true) {
                signupProcessingCallback();
                AuthService()
                    .registration(
                  email: _userEmail,
                  password: _password,
                )
                    .then((String message) {
                  signupProcessingCallback();
                  if (message.contains('Success')) {
                    firebaseServiceSignup.addUser(
                        _userEmail,
                        _userName,
                        _password,
                        _phoneNumber,
                        '',
                        _controller.selectedOptions
                            .map((e) => e.value!)
                            .toList(),
                        [],
                        [],
                        []);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Notice",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Please make sure you have entered your personal details correctly.',
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        TextButton(
                            child: const Text("OK",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 119, 71, 71))),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    );
                  },
                );
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)))),
            child: const Text(
              'Sign Up',
              style: TextStyle(color: Color.fromARGB(255, 119, 71, 71)),
            )));
  }

  Widget appTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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

  Widget usernameField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      margin: const EdgeInsets.only(right: 40, left: 40),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a username';
          } else if (value.trim().length > 25) {
            return 'Username must be less than 25 characters';
          } else {
            return null;
          }
        },
        onChanged: (value) => _userName = value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter a username',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
        ),
      ),
    );
  }

  Widget emailField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      margin: const EdgeInsets.only(right: 40, left: 40),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter an email';
          } else if (!isValidEmail(value)) {
            return 'Please enter a valid email';
          } else {
            return null;
          }
        },
        onChanged: (value) {
          _userEmail = value;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your email',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
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
        obscureText: true,
        onChanged: (value) {
          _password = value;
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a password';
          } else if (value.length < 6 || value.length > 20) {
            return 'Password must be 6-20 characters';
          } else if (!isValidPassword(value)) {
            return 'Require at least 1 capital letter and 1 special character';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your password',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
        ),
      ),
    );
  }

  Widget confirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      margin: const EdgeInsets.only(right: 40, left: 40),
      child: TextFormField(
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          } else if (value != _password) {
            return 'Passwords do not match';
          } else {
            return null;
          }
        },
        onChanged: (value) => _confirmPassword = value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Confirm your password',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
        ),
      ),
    );
  }

  Widget phoneNumberField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      margin: const EdgeInsets.only(right: 40, left: 40),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          } else if (value.length != 8 ||
              int.tryParse(value) == null ||
              (value[0] != '8' && value[0] != '9')) {
            return 'Please enter a valid phone number';
          } else {
            return null;
          }
        },
        onChanged: (value) => _phoneNumber = value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your phone number',
          contentPadding: EdgeInsets.only(left: 10, right: 10),
        ),
      ),
    );
  }

  Widget genreField() {
    return Container(
      margin: const EdgeInsets.only(right: 40, left: 40),
      child: MultiSelectDropDown(
        hint: 'Select your favourite genres',
        controller: _controller,
        onOptionSelected: (List<ValueItem> selectedOptions) {},
        options: const <ValueItem>[
          ValueItem(label: 'Adventure', value: 'Adventure'),
          ValueItem(label: 'Anthologies', value: 'Anthologies'),
          ValueItem(label: 'Art & Photography', value: 'Art & Photography'),
          ValueItem(
              label: 'Biography/Autobiography',
              value: 'Biography/Autobiography'),
          ValueItem(
              label: 'Business & Economics', value: 'Business & Economics'),
          ValueItem(label: 'Children\'s Fiction', value: 'Children\'s Fiction'),
          ValueItem(label: 'Classics', value: 'Classics'),
          ValueItem(
              label: 'Cooking, Food, & Wine', value: 'Cooking, Food, & Wine'),
          ValueItem(label: 'Drama/Play', value: 'Drama/Play'),
          ValueItem(label: 'Erotica', value: 'Erotica'),
          ValueItem(label: 'Essays', value: 'Essays'),
          ValueItem(
              label: 'Fairy Tales & Folklore', value: 'Fairy Tales & Folklore'),
          ValueItem(label: 'Fantasy', value: 'Fantasy'),
          ValueItem(
              label: 'Graphic Novels/Comics', value: 'Graphic Novels/Comics'),
          ValueItem(label: 'Health & Wellness', value: 'Health & Wellness'),
          ValueItem(label: 'Historical Fiction', value: 'Historical Fiction'),
          ValueItem(label: 'History', value: 'History'),
          ValueItem(label: 'Horror', value: 'Horror'),
          ValueItem(label: 'Humor', value: 'Humor'),
          ValueItem(label: 'Literary Fiction', value: 'Literary Fiction'),
          ValueItem(label: 'Memoir', value: 'Memoir'),
          ValueItem(label: 'Mystery', value: 'Mystery'),
          ValueItem(label: 'Philosophy', value: 'Philosophy'),
          ValueItem(label: 'Poetry', value: 'Poetry'),
          ValueItem(
              label: 'Politics & Current Affairs',
              value: 'Politics & Current Affairs'),
          ValueItem(label: 'Psychology', value: 'Psychology'),
          ValueItem(
              label: 'Religion & Spirituality',
              value: 'Religion & Spirituality'),
          ValueItem(label: 'Romance', value: 'Romance'),
          ValueItem(label: 'Satire', value: 'Satire'),
          ValueItem(label: 'Science', value: 'Science'),
          ValueItem(label: 'Science Fiction', value: 'Science Fiction'),
          ValueItem(label: 'Self-help', value: 'Self-help'),
          ValueItem(label: 'Short Stories', value: 'Short Stories'),
          ValueItem(label: 'Technology', value: 'Technology'),
          ValueItem(label: 'Thriller', value: 'Thriller'),
          ValueItem(label: 'Travel', value: 'Travel'),
          ValueItem(label: 'True Crime', value: 'True Crime'),
          ValueItem(label: 'Western', value: 'Western'),
          ValueItem(
              label: 'Young Adult (YA) Fiction',
              value: 'Young Adult (YA) Fiction'),
        ],
        selectionType: SelectionType.multi,
        chipConfig: const ChipConfig(wrapType: WrapType.wrap),
        dropdownHeight: 300,
        optionTextStyle: const TextStyle(fontSize: 16),
        selectedOptionIcon: const Icon(Icons.check_circle),
      ),
    );
  }

  Widget logo() {
    return Container(
      width: 170,
      height: 170,
      margin: const EdgeInsets.only(top: 10),
      child: Image.asset('assets/images/Logo1_nobg.png'),
    );
  }

  Widget backButton() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 20),
      child: IconButton(
          color: const Color.fromARGB(255, 149, 67, 67),
          iconSize: 35,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              )),
    );
  }
}
