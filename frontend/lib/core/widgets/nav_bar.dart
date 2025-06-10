import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; 

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex; 
  final Function(int) onItemTapped; 

  const CustomBottomNavBar({
  super.key, 
  required this.selectedIndex,
  required this.onItemTapped,
});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05), 
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2), 
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect( 
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.cardBackground, 
          currentIndex: widget.selectedIndex, 
          onTap: widget.onItemTapped, 
          selectedItemColor: AppColors.accent, 
          unselectedItemColor: AppColors.textSecondary, 
          showSelectedLabels: false,
          showUnselectedLabels: false, 
          type: BottomNavigationBarType.fixed, 
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 28), 
              label: 'Home',
              tooltip: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, size: 28),
              label: 'Bookings',
              tooltip: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28), 
              label: 'Profile',
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}