// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/features/provider/data/provider_model.dart'; 

class ProviderCard extends StatelessWidget {
  final Provider provider;
  final VoidCallback onDetailsTap;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Provider Avatar/Initial
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accent.withOpacity(0.2),
            child: Text(
              provider.username != null && provider.username!.isNotEmpty
                  ? provider.username![0].toUpperCase()
                  : '?',
              style: AppTextStyles.header.copyWith(color: AppColors.accent),
            ),
          ),
          const SizedBox(width: 16),

          // Provider Details (Name and Service)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.username ?? 'N/A', 
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  provider.category ?? 'Service Not Specified', 
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          ElevatedButton(
            onPressed: onDetailsTap,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }
}