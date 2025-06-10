import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_style.dart';
import '../../features/bookings/data/booking_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final String serviceName;
  final String serviceProviderName;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    required this.serviceName,
    required this.serviceProviderName,
    this.onReschedule,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.cardBackground, 
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceName,
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.textPrimary, 
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Service Provider', serviceProviderName),

            _buildDetailRow(
              'Service Date',
              DateFormat('MMM dd, yyyy - hh:mm a').format(booking.serviceDate),
            ),

            if (booking.bookingDate != null)
              _buildDetailRow(
                'Booked On',
                DateFormat('MMM dd, yyyy').format(booking.bookingDate!),
              ),

            if (_shouldShowActions(booking.status)) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildActionButtons(booking.status),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label    ', // Added extra spaces for better alignment
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return [
          Flexible(
            child: AppButton(
              text: 'Reschedule',
              onPressed: onReschedule,
              type: ButtonType.primary,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: AppButton(
              text: 'Cancel',
              onPressed: onCancel,
              type: ButtonType.red,
            ),
          ),
        ];
      case 'active':
        return [
          Flexible(
            child: AppButton(
              text: 'Cancel',
              onPressed: onCancel,
              type: ButtonType.red,
            ),
          ),
        ];
      default:
        return [];
    }
  }
  // Determines if action buttons should be shown based on booking status.
  bool _shouldShowActions(String status) {
    final lowerStatus = status.toLowerCase();
    return (lowerStatus == 'pending' || lowerStatus == 'active') &&
        (onReschedule != null || onCancel != null);
  }
}