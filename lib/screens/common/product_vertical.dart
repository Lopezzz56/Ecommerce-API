import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecomm/screens/ProductDetails/screens/ProductDetail.dart';

class ProductVertical extends StatelessWidget {
    final String imageUrl;
  final String title;
  final double price;
  final double rating;
  final String id;
  final String description;
  final String userId; // Add userId to this widget

  const ProductVertical({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.id,
    required this.description,
    required this.userId, // Include the userId here
  });
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
        Size size = MediaQuery.of(context).size;

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
      width: size.width,
      height: 120,
      //color: const Color.fromARGB(255, 251, 241, 199),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 150,
                decoration: BoxDecoration(
                  image:  DecorationImage(
                    image: NetworkImage(imageUrl),
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
                       trimTitle(title, ),
                        style:  GoogleFonts.cormorant(
                              textStyle: TextStyle(fontSize: 21),
                              fontWeight: FontWeight.bold, // Makes the text bold
                      color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis, 
                            maxLines: 1,),
                
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
              )
          ],
        ),
      ),
      ),
    );
  }
}