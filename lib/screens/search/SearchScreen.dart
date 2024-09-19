import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecomm/screens/common/BottomNav.dart';
import 'package:myecomm/screens/common/product_vertical.dart';
import 'package:myecomm/screens/search/search_service.dart';

import '../common/Search.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;
   final String userId; // Add userId to SearchScreen

  const SearchScreen({super.key, required this.searchQuery, required this.userId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   Future<List<Product>>? _futureProducts;
   final TextEditingController _searchController = TextEditingController();

  void _onSearchPressed() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      // Perform search or navigate to a search result page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(searchQuery: searchQuery,
          userId: widget.userId,),
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _futureProducts = SearchService.searchProducts(widget.searchQuery);  // Fetch filtered products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
         SizedBox(height: 5),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Search(
              searchController: _searchController,
              onSearchPressed: _onSearchPressed,
            ),
          ),
                 //   SizedBox(height: 5),

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      // Use the ProductVertical widget and pass product information as parameters
                      return ProductVertical(
                        imageUrl: product.image,
                        title: product.title,
                        price: product.price,        // Now passing price as a double
                        description: product.description,
                        rating: product.rating,
                        id: product.id.toString(),
                        userId: widget.userId,
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No results found.'));
                }
              },
            ),
          ),
        ],
      ),
      //bottomNavigationBar: BottomNav(),
    );
  }
}