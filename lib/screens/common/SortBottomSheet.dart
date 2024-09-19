import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sortbottomsheet {
  static void show(BuildContext context, Function(String) onSortSelected) {
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
                  'Sort By',
                  style: GoogleFonts.cormorant(
                    textStyle: TextStyle(fontSize: 28),
                    fontWeight: FontWeight.bold, // Makes the text bold
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
                    'Prices',
                    style: GoogleFonts.cormorant(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              // Prices Sorting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 165,
                    child: ElevatedButton(
                      onPressed: () {
                        onSortSelected('Price: Low to High');
                       // Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Low to High',
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 18),
                            fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 165,
                    child: ElevatedButton(
                      onPressed: () {
                        onSortSelected('Price: High to Low');
                        //Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'High to Low',
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 18),
                            fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ratings',
                    style: GoogleFonts.cormorant(
                      textStyle: TextStyle(fontSize: 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              // Ratings Sorting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        onSortSelected('Rating: Low to High');
                        //Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Low to High',
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 18),
                            fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        onSortSelected('Rating: High to Low');
                        //Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'High to Low',
                        style: GoogleFonts.cormorant(
                          textStyle: TextStyle(fontSize: 18),
                            fontWeight: FontWeight.bold, // Makes the text bold
                                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
