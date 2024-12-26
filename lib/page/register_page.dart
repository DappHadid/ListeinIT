import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:listenit/utils/rounded_button.dart';
import 'package:listenit/page/welcome_page.dart';

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

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance; // Tambahkan Firestore instance
  String email = '';
  String password = '';
  String role = 'user'; // Default role adalah user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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
                      // Logo image
                      Container(
                        height: 150,
                        child: Image.asset(
                          'assets/Logos.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        'Hey, Register Here...',
                        style: GoogleFonts.openSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Email input field
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your Email',
                            prefixIcon: const Icon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Password input field
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your Password',
                            prefixIcon: const Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Register button
                      RoundedButton(
                        colour: Colors.green,
                        title: 'Register',
                        onPressed: () async {
                          if (email.isEmpty || password.isEmpty) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.danger,
                                title: "Error",
                                text: "Email and Password cannot be empty!",
                              ),
                            );
                            return;
                          }

                          try {
                            // Mencoba membuat pengguna baru.
                            final userCredential =
                                await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            if (userCredential.user != null) {
                              // Simpan data ke Firestore
                              await _firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'email': email,
                                'role': role,
                              });

                              // Registrasi berhasil
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Registration Successful",
                                  text:
                                      "Your account has been created successfully!",
                                ),
                              ).then((_) {
                                // Navigasi berdasarkan role
                                if (role == 'admin') {
                                  Navigator.pushNamed(context, 'admin_screen');
                                } else {
                                  Navigator.pushNamed(context, 'user_screen');
                                }
                              });
                            }
                          } catch (e) {
                            // Menampilkan Sweet Alert untuk error.
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "Registration Failed",
                                text: e.toString(),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Already have an account? Login here',
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
