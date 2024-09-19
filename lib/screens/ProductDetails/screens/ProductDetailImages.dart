import 'package:flutter/material.dart';
import 'package:myecomm/screens/ProductDetails/screens/CurvesImage.dart';

class ProductDetailImages extends StatelessWidget {
  const ProductDetailImages({super.key, required this.imageUrl});
final String imageUrl;
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return  ClipPath(
      clipper: Curvesimage(),
child: Align(
  alignment: Alignment.topCenter,
  child: Center(
    child: Image(image: NetworkImage(imageUrl),
    fit: BoxFit.contain,
    height: size.height*0.6,
    width: size.width,
    ),
  ),
),
    );
  }
}