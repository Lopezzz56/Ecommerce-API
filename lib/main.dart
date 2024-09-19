import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myecomm/screens/Authentication/screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:myecomm/screens/ProductDetails/screens/ProductDetail.dart';
import 'package:myecomm/screens/ProductDetails/screens/ProductDetailImages.dart';
import 'package:myecomm/screens/cart/cartScreen.dart';
import 'package:myecomm/screens/common/BottomNav.dart';
import 'package:myecomm/screens/home/homescreen.dart';
import 'package:myecomm/screens/search/SearchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB1X5qi2b2KoqKtjOhhzfTYBS1W_F-38WM",
        appId: "1:323873566724:android:e141e820aed122cf1bc551",
        messagingSenderId: "323873566724",
        projectId: "ecomm-api-ba912",
      ),
    );

    // Enable persistence for Firebase Auth
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final userId = snapshot.data!.uid; // Get user ID
          return BottomNav(userId: userId); // Pass the userId to BottomNav
        } else {
          return LoginScreen(userId: '',); // Show login screen if user is not signed in
        }
      },
    );
  }
}
