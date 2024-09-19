import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchPressed;

  const Search({
    super.key,
    required this.searchController,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 340,
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          border: OutlineInputBorder(),
          hintText: 'Search',
          hintStyle: GoogleFonts.cormorant(
            textStyle: const TextStyle(fontSize: 18),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchPressed,  // Calls the search logic
          ),
        ),
      ),
    );
  }
}
