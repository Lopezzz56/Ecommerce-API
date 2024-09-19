import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myecomm/screens/ProductDetails/screens/ProductDetailImages.dart';
import 'package:myecomm/screens/cart/Cart_Model.dart';

import '../../cart/Cart_service.dart';

class ProductdetailScreen extends StatelessWidget {
   final String imageUrl;
  final String title;
  final double price;
  final double rating;
  final String id; // Product ID
  final String description;
  final String userId; // Add User ID

  const ProductdetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.id, // Receive ID here
    required this.description,
    required this.userId, // Pass User ID here
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
        Size size =MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 228, 203),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
         Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ProductDetailImages(imageUrl: imageUrl),
        ),
         Positioned(
          top: 40,
          left: 18,
            child:Container(
  decoration: BoxDecoration(
    color: Colors.white, // White background color
    borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3), // Shadow color
        spreadRadius: 2, // Spread radius
        blurRadius: 4, // Blur radius
        offset: Offset(0, 2), // Shadow offset (vertical and horizontal)
      ),
    ],
  ),
  child: IconButton(
    icon: Icon(Iconsax.arrow, size: 25, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
)


         ),
        // Scrollable Content
        Positioned(
          top: size.height * 0.41, // Adjust this value based on your needs
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60), // Adjust for space at the top if needed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 25),
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < rating ? Colors.amber : Colors.grey,
                             size: 22,
                         );
                        }),
                      ),
                      SizedBox(width: 8),
                      Text(
                        rating.toStringAsFixed(1),
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 22),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),],
                      ),
                      Text(
                        description,
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        maxLines: 6,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
       Positioned(
        bottom: 16,
          left: 16,
          right: 16,
         child: Container(
                  height: 56,
                  width: size.width,
                  child: ElevatedButton(
          onPressed: ()  { 
                // Logic to add the product to the cart
          addToCart(context);
          print("Button");
         
          }, 
          style: ElevatedButton.styleFrom(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10), // Set corner radius to 10
               ),
          ),
          child: Text(
               'ADD TO CART',
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
      ),
    );
  }
  // Logic to add product to cart using the CartService
  Future<void> addToCart(BuildContext context) async {
    final cartItem = CartItem(
      productId: id,
      title: title,
      price: price,
      quantity: 1,
      imageUrl: imageUrl,
      rating: rating,
      description: description
    );

    final cartService = CartService();

    // Save to Firebase using CartService
    try {
      await cartService.saveCartItemToFirebase(userId, cartItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title has been added to your cart!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item to cart: $e')),
      );
    }
  }
}
