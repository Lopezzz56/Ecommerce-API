import 'package:cloud_firestore/cloud_firestore.dart';
Future<Map<String, dynamic>?> getUserProfile(String userId) async {
  print('Fetching profile for user: $userId');
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    
    if (userDoc.exists) {
      print('User profile data: ${userDoc.data()}');
      return userDoc.data() as Map<String, dynamic>;
    } else {
      print('User not found.');
      return null;
    }
  } catch (e) {
    print('Error fetching user profile: $e');
    return null;
  }
}


