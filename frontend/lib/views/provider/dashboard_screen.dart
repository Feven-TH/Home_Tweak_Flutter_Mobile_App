// lib/screens/provider_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    // Watch the bookingState to rebuild the UI when the data or loading status changes
    final bookingState = ref.watch(bookingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background, // Sets the background color of the whole screen
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.accent, // Sets the app bar background color to accent
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28), // Profiles logo
            onPressed: () {
              // TODO: Implement navigation to profile page
              print('Navigate to profile page');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile page navigation not implemented yet!')),
              );
            },
          ),
          const SizedBox(width: 8), // Adds some spacing to the right of the icon
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Welcome back!', // "Welcome back" text
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'My Bookings', // "My Bookings" text
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            // Handles loading, error, empty states, and displays the list of bookings
            child: _buildBody(bookingState),
          ),
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