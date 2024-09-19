class CartItem {
  final String productId; // Same as id from the product schema
  final String title;
  final double price;
  final int quantity; // To track the quantity of the product in the cart
  final String imageUrl;
  final String description; 
  final double rating;

  CartItem( {
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });


  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
    };
  }

  // Create CartItem from Firebase Document
  static CartItem fromMap(Map<String, dynamic> map) {
    double price = map['price'] is int
        ? (map['price'] as int).toDouble()
        : (map['price'] as double? ?? 0.0);

    return CartItem(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      price: price,
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      rating: map['rating'] is int
          ? (map['rating'] as int).toDouble()
          : (map['rating'] as double? ?? 0.0),
    );
  }
}
