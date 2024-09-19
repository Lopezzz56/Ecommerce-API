import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myecomm/screens/Profile/ProfileScreen.dart';

import 'package:myecomm/screens/cart/cartScreen.dart';
import 'package:myecomm/screens/home/homescreen.dart';

class BottomNav extends StatelessWidget {
  final String userId; // Add userId parameter
  const BottomNav({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
final controller = Get.put(NavigationController(userId));
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const[
            NavigationDestination(icon: Icon(Iconsax.home), label: 'home',),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'cart'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'user'),
          ]),
      ),
      body: Obx(()=>controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final String userId; // Add userId parameter

  NavigationController(this.userId);
  final Rx<int> selectedIndex =0.obs;
  final screens = <Widget>[
    Homescreen(userId: '',), // Initialize later with userId
    CartScreen(userId: ''), // Initialize later with userId
    ProfileScreen(userId: "") // Initialize later with userId
  ];

  @override
  void onInit() {
    super.onInit();
    screens[0] = Homescreen(userId: userId); // Pass userId to Homescreen
    screens[1] = CartScreen(userId: userId); // Pass userId to CartScreen
    screens[2] = ProfileScreen(userId: userId); // Pass userId to Profilescreen
  }}