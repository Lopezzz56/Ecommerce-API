import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ProductDetails/screens/ProductDetail.dart';

class ProductHorizontal extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double rating;
  final String userId; // Add User ID
  final String id;
  final String description;
// double parseRating(dynamic rating) {
//   // Check if the rating is an integer, convert it to double if necessary
//   if (rating is int) {
//     return rating.toDouble();
//   } else if (rating is double) {
//     return rating;
//   } else {
//     return 0.0; // In case rating is null or something unexpected
//   }
// }
  const ProductHorizontal({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.id,
    required this.description, required this.userId, // Pass ID here
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
//Size size= MediaQuery.of(context).size;
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductdetailScreen(
              imageUrl: imageUrl,
              title: title,
              price: price,
              rating: rating,
              userId: userId,
              id: id, // Pass ID to the details screen
              description: description,
            ),
          ),
        );
      },
      child: Container(
        width: 165,
        height: 284,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image part
            Container(
              width: 165,
              height: 165,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain, // Adjust BoxFit if needed
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            // Info part
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      title,
                      style:  GoogleFonts.cormorant(
                            textStyle: TextStyle(fontSize: 18),
                            fontWeight: FontWeight.bold, // Makes the text bold
                    color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SizedBox(height: 5),
                    // Price
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style:  GoogleFonts.cormorant(
                            textStyle: TextStyle(fontSize: 18),
                            fontWeight: FontWeight.bold, // Makes the text bold
                    color: Colors.black87,
                          ),
                    ),
                    // Rating
                   Row(
                      children: [
                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
              Icons.star,
              color: index < rating ? Colors.amber : Colors.grey,
              size: 14,
                        );
                      }),
                    ),
                    SizedBox(width: 8), // Add some space between stars and rating text
                    // Rating Text
                    Text(
                      rating.toStringAsFixed(1), // Show rating with one decimal place
                      style:  GoogleFonts.cormorant(
                        textStyle: TextStyle(fontSize: 14),
              fontWeight: FontWeight.bold, // Makes the text bold
                    color: Colors.black87,
                          ),
                    ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
