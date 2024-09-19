import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Filterbottomsheet {
  static void show(BuildContext context, 
      {required Function(String, {double minPrice, double maxPrice, double minRating}) onFilterSelected}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Filter',
                  style: GoogleFonts.cormorant(
                    textStyle: TextStyle(fontSize: 28),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    style: GoogleFonts.cormorant(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              // Categories Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton(context, 'men\'s clothing', onFilterSelected),
                  _buildCategoryButton(context, 'women\'s clothing', onFilterSelected),
                ],
              ),
              // Categories Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton(context, 'jewelery', onFilterSelected),
                  _buildCategoryButton(context, 'electronics', onFilterSelected),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Prices',
                    style: GoogleFonts.cormorant(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriceButton(context, 'Below \$50', onFilterSelected),
                  _buildPriceButton(context, 'Above \$50', onFilterSelected),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildCategoryButton(BuildContext context, String category, Function(String, {double minPrice, double maxPrice, double minRating}) onFilterSelected) {
    return Container(
      width: 170,
      child: ElevatedButton(
        onPressed: () {
          onFilterSelected(category, minPrice: 0.0, maxPrice: double.infinity, minRating: 0.0);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          category,
          style: GoogleFonts.cormorant(
            textStyle: TextStyle(fontSize: 18),
              fontWeight: FontWeight.bold, // Makes the text bold
                                          color: const Color.fromARGB(221, 32, 30, 30),
          ),
        ),
      ),
    );
  }

  static Widget _buildPriceButton(BuildContext context, String priceRange, Function(String, {double minPrice, double maxPrice, double minRating}) onFilterSelected) {
    double minPrice = 0.0;
    double maxPrice = double.infinity;

    if (priceRange == 'Below \$50') {
      maxPrice = 50.0;
    } else if (priceRange == 'Above \$50') {
      minPrice = 50.0;
    }

    return Container(
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          onFilterSelected('All', minPrice: minPrice, maxPrice: maxPrice, minRating: 0.0);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          priceRange,
          style: GoogleFonts.cormorant(
            textStyle: TextStyle(fontSize: 18),
              fontWeight: FontWeight.bold, // Makes the text bold
                                          color: const Color.fromARGB(221, 45, 42, 42),
          ),
        ),
      ),
    );
  }
}
