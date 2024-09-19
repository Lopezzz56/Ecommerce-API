import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myecomm/screens/cart/Cart_Model.dart';


class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> checkout(String userId, double totalPrice) async {
    try {
      // Get all cart items for the user
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      // Add each cart item to the orders collection
      for (var doc in cartSnapshot.docs) {
        final cartItem = CartItem.fromMap(doc.data() as Map<String, dynamic>);
        
        // Add to orders collection with total price
        await _firestore.collection('orders').add({
          'userId': userId,
          'productId': cartItem.productId,
          'title': cartItem.title,
          'price': cartItem.price,
          'quantity': cartItem.quantity,
          'imageUrl': cartItem.imageUrl,
          'totalPrice': totalPrice, // Total price added here
          'timestamp': FieldValue.serverTimestamp(), // Order time tracking
        });

        // Remove from cart collection
        await _firestore.collection('users').doc(userId).collection('cart').doc(doc.id).delete();
      }
      
    } catch (e) {
      print('Error during checkout: $e');
    }
  }

  // Method to save a CartItem to Firestore
 Future<void> saveCartItemToFirebase(String userId, CartItem cartItem) async {
  print('Saving cart item for user: $userId');
  final userCartRef = _firestore.collection('users').doc(userId).collection('cart');

  try {
    final existingCartItem = await userCartRef.doc(cartItem.productId).get();

    if (existingCartItem.exists) {
      print('Cart item already exists, updating quantity.');
      final existingData = existingCartItem.data();
      final existingQuantity = existingData?['quantity'] ?? 0;

      await userCartRef.doc(cartItem.productId).update({
        'quantity': existingQuantity + 1,
      });
    } else {
      print('Cart item does not exist, adding to cart.');
      await userCartRef.doc(cartItem.productId).set(cartItem.toMap());
    }
    print('Cart item saved successfully.');
  } catch (e) {
    print('Error saving cart item: $e');
  }
}


  // Additional methods for handling cart items can be added here
}
