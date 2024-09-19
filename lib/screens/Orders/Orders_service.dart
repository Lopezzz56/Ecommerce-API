import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
  try {
    QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    
    return orderSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'orderId': doc.id,
        'totalPrice': data.containsKey('totalPrice') ? (data['totalPrice'] ?? 0.0) : 0.0,
        'productId': data['productId'] ?? '',
        'title': data['title'] ?? '',
        'price': (data['price'] ?? 0).toDouble(),
        'quantity': data['quantity'] ?? 1,
        'imageUrl': data['imageUrl'] ?? '',
      };
    }).toList();
  } catch (e) {
    print('Error fetching orders: $e');
    return [];
  }
}

