import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart'; 
import 'package:frontend/core/theme/app_text_style.dart'; 

class CategoryItem extends StatelessWidget {
  final String iconPath; 
  final String label; 
  final VoidCallback onTap; 
  final bool isSelected; 

  const CategoryItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, 
        margin: const EdgeInsets.symmetric(horizontal: 6.0), 
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.cardBackground, // Highlight selected
          borderRadius: BorderRadius.circular(12), 
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: AppColors.textPrimary.withOpacity(0.05), 
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 50, 
              height: 50,
            ),
            const SizedBox(height: 4), 
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, 
            ),
          ],
        ),
      ),
    );
  }
}