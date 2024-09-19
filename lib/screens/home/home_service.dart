import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeService {
  // Simulate pagination by fetching all products and slicing them
  Future<List<dynamic>> fetchProducts({int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<dynamic> allProducts = json.decode(response.body);
        
        // Paginate locally by slicing the list
        int startIndex = (page - 1) * limit;
        int endIndex = startIndex + limit;
        
        return allProducts.sublist(startIndex, endIndex > allProducts.length ? allProducts.length : endIndex);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}
