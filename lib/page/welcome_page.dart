import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listenit/page/register_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:listenit/utils/rounded_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_admin.dart';
import 'dashboard_user.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
  filled: true,
  fillColor: Color(0xFF2C2C2C),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  bool _isLoading = false;

  Future<void> _navigateBasedOnRole(String email) async {
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first; // Ambil dokumen pertama
        final role = userDoc['role'];
        if (role == 'admin') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardAdmin()));
        } else if (role == 'user') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardUser()));
        } else {
          throw 'Unknown role';
        }
      } else {
        throw 'User  document not found';
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error determining role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.grey[700]!,
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.grey[700]!,
                        Colors.black,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: Image.asset(
                          'assets/LOGO.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        'Log In to ListenIT',
                        style: GoogleFonts.openSans(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: kTextFieldDecoration.copyWith(
                            filled: true,
                            fillColor: Colors.grey[800],
                            hintText: 'Enter your Email',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: kTextFieldDecoration.copyWith(
                            filled: true,
                            fillColor: Colors.grey[800],
                            hintText: 'Enter your Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      RoundedButton(
                        colour: Colors.green,
                        title: 'Login',
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            final UserCredential =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (UserCredential.user != null) {
                              await _navigateBasedOnRole(email);
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      ),
                      _isLoading
                          ? Center(
                              child: LoadingAnimationWidget.inkDrop(
                                color: Colors.greenAccent,
                                size: 100,
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Don’t have an account? Register here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
