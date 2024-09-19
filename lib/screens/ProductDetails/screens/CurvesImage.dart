import 'package:flutter/material.dart';

class Curvesimage extends CustomClipper<Path>{
@override
Path getClip(Size size){
  Path path=Path();
  path.lineTo(0, size.height);
 Offset curve1 = Offset(0, size.height * 0.8);
 Offset curve2 = Offset(size.width * 0.25, size.height * 0.8);
path.quadraticBezierTo(curve1.dx, curve1.dy, curve2.dx, curve2.dy);
path.lineTo(size.width * 0.25, size.height*0.8);
 Offset curve3 = Offset(size.width, size.height * 0.8);
 Offset curve4 = Offset(size.width, size.height * 0.65);
path.quadraticBezierTo(curve3.dx, curve3.dy, curve4.dx, curve3.dy);
path.lineTo(size.width, 0);
path.close();
return path;
}
// bool imageRect(covariant CustomClipper<Path> oldClipper){
// return false;
//   }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
return false;
  } }