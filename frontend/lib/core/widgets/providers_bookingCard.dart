import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../features/bookings/data/booking_model.dart'; // Ensure this path is correct

// Define AppColors class (assuming it's in a shared location or placed here for now)
class AppColors {
  static const Color accent = Color(0xFFFF6700);
  static const Color background = Color(0xFFFFF9F5);
  static const Color textPrimary = Color(0xFF04285E);
  static const Color textSecondary = Color(0xFF4F5255);
  static const Color cardBackground = Color(0xFFFFEEE3);
}

class BookingCard extends StatefulWidget { // CHANGED: Made StatefulWidget
  final Booking booking;
  // ADDED: Callback for confirming the booking. Takes booking ID and new status.
  final Future<void> Function(int bookingId, String newStatus) onConfirm;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onConfirm, // ADDED: Requires onConfirm callback
  }) : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  late String _currentStatus; // ADDED: Local state to manage status
  bool _isConfirming = false; // ADDED: To manage loading state of the button

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.booking.status; // ADDED: Initialize status from widget
  }

  // ADDED: Method to handle confirmation
  Future<void> _handleConfirm() async {
    setState(() {
      _isConfirming = true; // Show loading indicator
    });
    try {
      await widget.onConfirm(widget.booking.id!, 'Confirmed'); // Call the passed callback
      setState(() {
        _currentStatus = 'Confirmed'; // Update local status on success
      });
      ScaffoldMessenger.of(context).showSnackBar( // Show success message
        const SnackBar(content: Text('Booking confirmed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( // Show error message
        SnackBar(content: Text('Failed to confirm booking: $e')),
      );
    } finally {
      setState(() {
        _isConfirming = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedServiceDate =
        DateFormat('MMM d, EEEE h:mm a').format(widget.booking.serviceDate.toLocal()); // CHANGED: Use widget.booking

    Color statusColor;
    IconData statusIcon;
    switch (_currentStatus) { // CHANGED: Use _currentStatus for display
      case 'Confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'Pending':
        statusColor = AppColors.accent; // CHANGED: Using AppColors.accent for pending status
        statusIcon = Icons.pending_actions;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info_outline;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.cardBackground, // CHANGED: Using AppColors.cardBackground
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Name (User's Name) - IMPORTANT: This is for the Provider's view
            if (widget.booking.customerUsername != null && widget.booking.customerUsername!.isNotEmpty) // CHANGED: Use widget.booking
              _buildInfoRow(
                icon: Icons.person_outline,
                label: 'Customer',
                value: widget.booking.customerUsername!, // CHANGED: Use widget.booking
                valueStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary), // CHANGED: Using AppColors
              ),
            // REMOVED: Provider Name as this is provider's view
            // REMOVED: Service Category Name as it's not relevant for this view/JSON
            
            const Divider(height: 20, thickness: 1),

            // Service Date & Time
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Date & Time',
              value: formattedServiceDate,
              valueStyle: const TextStyle(fontSize: 15, color: AppColors.textSecondary), // CHANGED: Using AppColors
            ),
            const SizedBox(height: 8),

            // Status
            Row(
              children: [
                Icon(statusIcon, size: 18.0, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  'Status: $_currentStatus', // CHANGED: Display _currentStatus
                  style: TextStyle(
                    fontSize: 15,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(), // ADDED: Pushes button to the right

                // Confirm Button (only shows if status is Pending)
                if (_currentStatus == 'Pending') // ADDED: Conditional button
                  ElevatedButton(
                    onPressed: _isConfirming ? null : _handleConfirm, // ADDED: Disable if confirming
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent, // CHANGED: Using AppColors.accent
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isConfirming // ADDED: Loading indicator
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build consistent info rows (reused from previous version)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: AppColors.textSecondary), // CHANGED: Using AppColors.textSecondary
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary, // CHANGED: Using AppColors.textSecondary
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  value,
                  style: valueStyle ?? const TextStyle(fontSize: 15, color: AppColors.textPrimary), // CHANGED: Using AppColors.textPrimary
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}