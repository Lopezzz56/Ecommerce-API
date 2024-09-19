import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // To decode JSON data
import 'package:http/http.dart' as http; // For API calls
import 'package:iconsax/iconsax.dart';
import 'package:myecomm/screens/ProductDetails/screens/ProductDetail.dart';
import 'package:myecomm/screens/common/FIlterBottomSheet.dart';
import 'package:myecomm/screens/common/Product_horizontal.dart';
import 'package:myecomm/screens/common/Search.dart';
import 'package:myecomm/screens/common/SortBottomSheet.dart';
import 'home_service.dart';
import '../search/SearchScreen.dart';

class Homescreen extends StatefulWidget {
    final String userId;
  const Homescreen({super.key, required this.userId});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
    List products = []; // Holds all the products fetched
  List displayedProducts = []; // Products to be displayed initially
  int currentPage = 1; // Current page to track the number of products displayed
bool isLoadingMore = false; // Track loading state
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();
  final HomeService _homeService = HomeService(); // Instantiate service

  String _selectedCategory = 'All';
  double _minPrice = 0.0;
  double _maxPrice = double.infinity;
  double _minRating = 0.0;

double parsedRating(dynamic rating) {
  if (rating is int) {
    return rating.toDouble();
  } else if (rating is double) {
    return rating;
  } else {
    return 0.0; // Default to 0.0
  }
}
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
    fetchProducts(); // Fetch products when the screen is initialized
   _scrollController.addListener(_onScroll); // Add scroll listener

  }


  // Fetch products with pagination
  Future<void> fetchProducts() async {
    if (!hasMore) return; // Exit if no more products to load

    setState(() {
      isLoadingMore = true; // Start loading state
    });

    try {
      List newProducts = await _homeService.fetchProducts(page: currentPage);

      setState(() {
        // If fewer than 10 products are returned, we assume there are no more to load
        if (newProducts.length < 10) {
          hasMore = false; // No more products to load
        }
        products.addAll(newProducts); // Append the new products
        currentPage++; // Increment the page number
        isLoadingMore = false; // Reset loading state
          // Apply filter and sort after fetching new products
        filterProducts(_selectedCategory, minPrice: _minPrice, maxPrice: _maxPrice, minRating: _minRating);
       // sortProducts(_sortCriteria);
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  
void sortProducts(String criteria) {
  setState(() {
    // Sorting displayedProducts, which contains the filtered list
    if (criteria == 'Price: Low to High') {
      displayedProducts.sort((a, b) {
        double priceA = a['price'] is int ? (a['price'] as int).toDouble() : a['price'] as double;
        double priceB = b['price'] is int ? (b['price'] as int).toDouble() : b['price'] as double;
        return priceA.compareTo(priceB);
      });
    } else if (criteria == 'Price: High to Low') {
      displayedProducts.sort((a, b) {
        double priceA = a['price'] is int ? (a['price'] as int).toDouble() : a['price'] as double;
        double priceB = b['price'] is int ? (b['price'] as int).toDouble() : b['price'] as double;
        return priceB.compareTo(priceA);
      });
    } else if (criteria == 'Rating: Low to High') {
      displayedProducts.sort((a, b) {
        double ratingA = a['rating']['rate'] is int ? (a['rating']['rate'] as int).toDouble() : a['rating']['rate'] as double;
        double ratingB = b['rating']['rate'] is int ? (b['rating']['rate'] as int).toDouble() : b['rating']['rate'] as double;
        return ratingA.compareTo(ratingB);
      });
    } else if (criteria == 'Rating: High to Low') {
      displayedProducts.sort((a, b) {
        double ratingA = a['rating']['rate'] is int ? (a['rating']['rate'] as int).toDouble() : a['rating']['rate'] as double;
        double ratingB = b['rating']['rate'] is int ? (b['rating']['rate'] as int).toDouble() : b['rating']['rate'] as double;
        return ratingB.compareTo(ratingA);
      });
    }
  });
}



 void filterProducts(String category, {double minPrice = 0.0, double maxPrice = double.infinity, double minRating = 0.0}) {
 // print('Filtering category: $category'); // Debugging
  setState(() {
    _selectedCategory = category;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _minRating = minRating;

    // Filter the products list
    displayedProducts = products.where((product) {
      final productPrice = product['price'] is int
          ? (product['price'] as int).toDouble()
          : product['price'] as double;
      final productRating = parsedRating(product['rating']['rate']);
      return (category == 'All' || product['category'] == category) &&
             productPrice >= minPrice &&
             productPrice <= maxPrice &&
             productRating >= minRating;

    // Debugging: Check how many products remain after filtering
    //print('Filtered Products: ${displayedProducts.length}');
    }).toList();
  });
}


  // Trigger loading more products on scroll
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        hasMore) {
      fetchProducts(); // Load more products
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
       controller: _scrollController,
          children: [
            SizedBox(height: 5),
            // Search Bar
          Search(
             searchController: _searchController,
            onSearchPressed: _onSearchPressed,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Sortbottomsheet.show(context, (String criteria) {
      sortProducts(criteria);
                     });
                  },
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sort",
                        style:  GoogleFonts.cormorant(
                                textStyle: TextStyle(fontSize: 21),
                                fontWeight: FontWeight.bold, // Makes the text bold
                        color: Colors.black87,)
                      ),
                      Icon(Iconsax.sort,
                       color: Colors.black,
                              size: 14,)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                Filterbottomsheet.show(context, 
                  onFilterSelected: (category, {double minPrice = 0.0, double maxPrice = double.infinity, double minRating = 0.0}) {
                                          filterProducts(category, minPrice: minPrice, maxPrice: maxPrice, minRating: minRating);
                                        });
//filterProducts('electronics'); // Hard-coded for testing
                      },
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Filter",
                        style:  GoogleFonts.cormorant(
                                textStyle: TextStyle(fontSize: 21),
                                fontWeight: FontWeight.bold, // Makes the text bold
                        color: Colors.black87,)
                      ),
                      Icon(Iconsax.filter,
                       color: Colors.black,
                              size: 14,)
                    ],
                  ),
                )
              ],
            ),
            ),
          ),

            SizedBox(height: 15),
            // Product List
         

            products.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Show loading while products are fetched
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 165 / 260,
                    ),
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductdetailScreen(
                                imageUrl: product['image'],
                                title: product['title'],
                                price: double.tryParse(product['price'].toString()) ?? 0.0,
                                rating: product['rating']['rate'] is int
                                    ? (product['rating']['rate'] as int).toDouble()
                                    : product['rating']['rate'],
                                id: product['id'].toString(),
                                description: product['description'],
                                 userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        child: ProductHorizontal(
                          imageUrl: product['image'],
                          title: product['title'],
                          price: double.tryParse(product['price'].toString()) ?? 0.0,
                          rating: product['rating']['rate'] is int
                              ? (product['rating']['rate'] as int).toDouble()
                              : product['rating']['rate'],
                          id: product['id'].toString(),
                          description: product['description'],
                           userId: widget.userId,
                        ),
                      );
                    },
                  ),
            if (isLoadingMore) // Loading indicator for infinite scrolling
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      
      // bottomNavigationBar: BottomNav(),
    );
  }
}
