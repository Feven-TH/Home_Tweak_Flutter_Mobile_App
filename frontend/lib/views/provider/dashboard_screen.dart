// lib/screens/provider_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import your existing files
import '../../core/theme/app_colors.dart';         // Your AppColors definitions
import '../../features/bookings/presentation/booking_state.dart';           // Your BookingState definition
import '../../core/widgets/providers_bookingCard.dart' as booking_card;         // Your BookingCard widget
import '../../features/bookings/presentation/booking_provider.dart';   // The file where bookingNotifierProvider is defined
// Ensure your Booking model is correctly imported where needed (e.g., in booking_card, booking_state)


class ProviderDashboardScreen extends ConsumerStatefulWidget {
  final int providerId; // The ID of the provider whose bookings we want to see

  const ProviderDashboardScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends ConsumerState<ProviderDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch bookings for the provider when the screen initializes
    // Using Future.microtask to ensure initState completes before the async call
    Future.microtask(() => _fetchBookings());
  }

  // Method to fetch bookings for the current provider using the notifier
  Future<void> _fetchBookings() async {
    await ref.read(bookingNotifierProvider.notifier).loadBookingsByProvider(widget.providerId);
  }

  // Navigation methods
  void _navigateToFinishSignUp() {
    context.push('/finish-signup', extra: {
      'providerId': widget.providerId,
      'isServiceProvider': true,
    });
  }

  void _navigateToProviderProfile() {
    context.push('/provider-profile/${widget.providerId}');
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.accent,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: _navigateToProviderProfile, // Updated to use new method
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                ElevatedButton(
                  onPressed: _navigateToFinishSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Complete Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // ... (rest of your existing body code)
        ],
      ),
    );
  }

  Widget _buildBody(BookingState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    } else if (state.error != null) {
      return Center(
        child: Text('Error: ${state.error}', style: const TextStyle(color: Colors.red, fontSize: 16)),
      );
    } else if (state.bookings.isEmpty) {
      return Center(
        child: Text(
          'No bookings found.',
          style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 16.0), // Padding for the bottom of the list
        itemCount: state.bookings.length,
        itemBuilder: (context, index) {
          final booking = state.bookings[index];
          return booking_card.BookingCard(
            booking: booking,
            // Pass the onConfirm callback, which calls the notifier's updateStatus
            // and then re-fetches the full list to update the UI globally.
            onConfirm: (bookingId, newStatus) async {
              try {
                await ref.read(bookingNotifierProvider.notifier).updateStatus(bookingId, newStatus);
                await _fetchBookings(); // Re-fetch all bookings to update the list
              } catch (e) {
                // Error handling is also done within BookingCard via SnackBar
                print("Error confirming booking in screen: $e");
              }
            },
          );
        },
      );
    }
  }
}