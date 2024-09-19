import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP Function
  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String phone, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'email': email,
          'phone': phone,
          'username': username,
          'createdAt': Timestamp.now(),
        });
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      return null; // Or you can rethrow the error if you want to handle it in the UI layer
    } catch (e) {
      print("An unexpected error occurred: $e");
      return null;
    }
  }

  // LOG IN Function
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific error codes
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided.");
      } else if (e.code == 'network-request-failed') {
        print("Network error: Please check your connection.");
      } else {
        print("Error: ${e.message}");
      }
      return null;
    } catch (e) {
      print("An unexpected error occurred: $e");
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
