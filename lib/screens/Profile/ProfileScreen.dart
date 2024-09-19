import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecomm/screens/Authentication/screens/loginscreen.dart';
import 'package:myecomm/screens/Orders/OrderPage.dart';
import 'package:myecomm/screens/Profile/profile_service.dart';


class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    String userId = widget.userId;
    var data = await getUserProfile(userId);
    if (data != null) {
      setState(() {
        userData = data;
      });
    } else {
      print('User profile not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
     Size size =MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 56,
        width: size.width,
       // margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: ListTile(
            title: Text('Username: ${userData!['username'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
      Container(
        height: 56,
        width: size.width,
      // margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: ListTile(
            title: Text('Phone: ${userData!['phone'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
      Container(
        height: 56,
        width: size.width,
        //margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: ListTile(
            title: Text('Email: ${userData!['email'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
      SizedBox(height: 30),
      Container(
        height: 56,
        width: size.width,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersScreen(userId: widget.userId),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Set corner radius to 10
            ),
          ),
          child: Text(
            'VIEW ORDERS',
            style: GoogleFonts.cormorant(
              textStyle: TextStyle(fontSize: 18),
              fontWeight: FontWeight.bold, // Makes the text bold
              color: Colors.black87,
            ),
          ),
        ),
      ),
    ],
  ),
),

    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(userId: "")),
    );
  }
}
