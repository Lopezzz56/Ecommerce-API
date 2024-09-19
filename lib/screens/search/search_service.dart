// search_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;  // Added description
  final double rating;        // Added rating

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
  });

factory Product.fromJson(Map<String, dynamic> json) {
   // Handle price conversion here
    double price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : (json['price'] as double);
    return Product(
      id: json['id'],
      title: json['title'],
      price: price,
      image: json['image'],
      description: json['description'] ?? '',  // Handle missing description
      rating: json['rating'] != null 
              ? (json['rating']['rate'] is int 
                  ? (json['rating']['rate'] as int).toDouble() 
                  : json['rating']['rate'].toDouble())
              : 0.0,  // Handle missing rating
    );
  }
}
class SearchService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  // Fetch all products from the API
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Search products by query
  static Future<List<Product>> searchProducts(String query) async {
    final allProducts = await fetchProducts();
    query = query.toLowerCase();
    return allProducts.where((product) {
      return product.title.toLowerCase().contains(query);
    }).toList();
  }

  // Fetch products by category
  static Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/category/$category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch products with a limit
  static Future<List<Product>> fetchProductsWithLimit(int limit) async {
    final response = await http.get(Uri.parse('$_baseUrl?limit=$limit'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch sorted products
  static Future<List<Product>> fetchSortedProducts({String sort = 'asc'}) async {
    final response = await http.get(Uri.parse('$_baseUrl?sort=$sort'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch all categories
  static Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load categories');
    }
  }
}