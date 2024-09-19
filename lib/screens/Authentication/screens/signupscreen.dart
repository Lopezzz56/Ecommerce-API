import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecomm/screens/Authentication/auth_service.dart';
import 'package:myecomm/screens/Authentication/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myecomm/screens/common/BottomNav.dart'; // Import Firebase Auth
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                'Let’s Create an Account',
                style: GoogleFonts.cormorant(
                  textStyle: TextStyle(fontSize: 20),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              _buildTextField(_usernameController, 'Username'),
              SizedBox(height: 25),
              _buildTextField(_emailController, 'Email'),
              SizedBox(height: 25),
              _buildTextField(_phoneController, 'Number'),
              SizedBox(height: 25),
              _buildTextField(_passwordController, 'Password', isPassword: true),
              SizedBox(height: 37),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 56,
                  width: 337,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.cormorant(
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildLoginText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isPassword = false}) {
    return Container(
      height: 56,
      width: 337,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: GoogleFonts.cormorant(),
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Already Registered ',
                style: GoogleFonts.cormorant(
                  textStyle: TextStyle(color: Colors.black),
                ),
              ),
              TextSpan(
                text: 'Log In',
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
                          builder: (context) => const LoginScreen(userId: "",)),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
void _signUp() async {
  setState(() {
    isSigningUp = true;
  });

  String username = _usernameController.text.trim();
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();
  String phone = _phoneController.text.trim();

  if (username.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
    _showSnackBar(context, "Please fill all fields.");
    setState(() {
      isSigningUp = false;
    });
    return;
  }

  try {
    // Call FirebaseAuthService's create user method
    User? user = await _auth.createUserWithEmailAndPassword(email, password, phone, username);

    if (user != null) {
      _showSnackBar(context, "Account created successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNav(userId: user.uid)), // Navigate after success
      );
    } else {
      _showSnackBar(context, "Failed to create account.");
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage = '';

    // Handle FirebaseAuth-specific errors
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'The email is already in use by another account.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'weak-password':
        errorMessage = 'The password is too weak.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Email/password accounts are not enabled.';
        break;
      default:
        errorMessage = 'An unknown error occurred.';
    }

    _showSnackBar(context, errorMessage);
  } finally {
    setState(() {
      isSigningUp = false;
    });
  }
}
}
