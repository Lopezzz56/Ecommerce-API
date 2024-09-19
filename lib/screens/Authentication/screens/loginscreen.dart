import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecomm/screens/Authentication/auth_service.dart';
import 'package:myecomm/screens/Authentication/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myecomm/screens/common/BottomNav.dart';
import 'package:myecomm/screens/home/homescreen.dart'; // Import Firebase Authentication

class LoginScreen extends StatefulWidget {
  final String userId;
  const LoginScreen({super.key, required this.userId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(height: 150),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/lock.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 64),
              Text(
                'Welcome Back You have been missed!',
                style: GoogleFonts.cormorant(
                  textStyle: TextStyle(fontSize: 20),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Container(
                height: 56,
                width: 337,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: GoogleFonts.cormorant(),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                height: 56,
                width: 337,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: GoogleFonts.cormorant(),
                  ),
                ),
              ),
              SizedBox(height: 37),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 56,
                  width: 337,
                  child: ElevatedButton(
                    onPressed: _login, // Call login function here
                    child: Text(
                      'LOG IN',
                      style: GoogleFonts.cormorant(
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Not Registered? ',
                          style: GoogleFonts.cormorant(
                            textStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: GoogleFonts.cormorant(
                            textStyle: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }
 void _login() async {
  setState(() {
    _isSigning = true;
  });

  String email = _emailController.text;
  String password = _passwordController.text;

  try {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      print("User is successfully signed in");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNav(userId: user.uid), // Pass the userId
        ),
      );
    } else {
      print("Some error occurred");
    }
  } catch (e) {
    setState(() {
      _isSigning = false;
    });
    print("Error: $e"); // Optionally show a snackbar or alert with this message
    // You can also use _showSnackBar(context, 'Error: $e') if needed
  }
}

}
