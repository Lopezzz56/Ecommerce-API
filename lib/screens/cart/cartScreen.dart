import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecomm/screens/cart/Cart_Model.dart';
import 'package:myecomm/screens/cart/Cart_service.dart';

import '../ProductDetails/screens/ProductDetail.dart';

class CartScreen extends StatelessWidget {
  final String userId;

  const CartScreen({Key? key, required this.userId}) : super(key: key);

String trimTitle(String title, {int maxChars = 18}) {
  // Function to capitalize the first letter and lowercase the rest
  String capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  // Apply capitalization to each word in the title
  String capitalizedTitle = title.split(' ').map((word) => capitalize(word)).join(' ');

  // Trim the title to maxChars if it exceeds the character limit
  if (capitalizedTitle.length <= maxChars) {
    return capitalizedTitle;
  } else {
    return capitalizedTitle.substring(0, maxChars) + '...'; // Append ellipsis if trimmed
  }
}
  @override
  Widget build(BuildContext context) {
            Size size =MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Your Cart"),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('cart')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Your cart is empty.'));
              }

              final cartItems = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return CartItem.fromMap(data);
              }).toList();

              double totalPrice = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductdetailScreen(
                                  imageUrl: item.imageUrl,
                                  title: item.title,
                                  price: item.price,
                                  rating: item.rating,
                                  userId: userId,
                                  id: item.productId, // Pass ID to the details screen
                                  description: item.description,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(item.imageUrl),
                                      fit: BoxFit.contain, // Adjust BoxFit if needed
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        trimTitle(item.title),
                                        style: GoogleFonts.cormorant(
                                          textStyle: TextStyle(fontSize: 21),
                                          fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)}',
                                        style: GoogleFonts.cormorant(
                                          textStyle: TextStyle(fontSize: 18),
                                          fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                                        ),
                                      ),
                                // Quantity controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            if (item.quantity > 1) {
                              // Decrease quantity
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection('cart')
                                  .doc(item.productId)
                                  .update({'quantity': item.quantity - 1});
                            }
                          },
                        ),
                        Text(
                          item.quantity.toString(),
                          style: GoogleFonts.cormorant(
                                          textStyle: TextStyle(fontSize: 20),
                                          fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                                        ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            // Increase quantity
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .collection('cart')
                                .doc(item.productId)
                                .update({'quantity': item.quantity + 1});
                          },
                        ),
                            ],
                                  ),
                                     
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Checkout button
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      height: 56,
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          final cartService = CartService();
                          await cartService.checkout(userId, totalPrice); // Pass totalPrice to the checkout method
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Checkout successful!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Set corner radius to 10
                          ),
                        ),
                        child: Text(
                          'CHECKOUT \$${totalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.cormorant(
                            textStyle: TextStyle(fontSize: 18),
                              fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
