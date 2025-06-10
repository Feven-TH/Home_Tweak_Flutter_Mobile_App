import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart'; 
import 'package:frontend/core/theme/app_text_style.dart'; 
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/core/widgets/booking_card.dart'; 
import 'package:frontend/views/customer/book_service_screen.dart'; 
import 'package:frontend/core/widgets/nav_bar.dart'; //


final selectedBookingFilterProvider = StateProvider<String>((ref) => 'Active');

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  int _selectedIndex = 1; // Assuming 'Bookings' is the second item (index 1)

  @override
  void initState() {
    super.initState();
    // Initial load of bookings based on the default filter (Active) and a dummy user ID
    _loadBookingsForFilter(ref.read(selectedBookingFilterProvider));
  }

  void _loadBookingsForFilter(String status) {
    ref.read(bookingNotifierProvider.notifier).loadBookings(1, status);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- Reschedule Logic ---
  void _onReschedule(Booking booking) {
    // You'll likely need to pass the providerId and perhaps the bookingId
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProviderDetailsScreen(
          providerId: booking.providerId,
          // currentBooking: booking,
        ),
      ),
    );
  }

  // --- Cancel Logic ---
  void _onCancel(int bookingId) async {
    // Show a confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Call the cancel use case via the notifier
      await ref.read(bookingNotifierProvider.notifier).cancel(bookingId);

      // After cancellation, re-load bookings for the current filter
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(bookingNotifierProvider).error != null
                  ? 'Failed to cancel booking: ${ref.read(bookingNotifierProvider).error}'
                  : 'Booking cancelled successfully!',
            ),
            backgroundColor: ref.read(bookingNotifierProvider).error != null
                ? AppColors.accent
                : AppColors.textPrimary, 
          ),
        );
        _loadBookingsForFilter(ref.read(selectedBookingFilterProvider));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current filter
    final selectedFilter = ref.watch(selectedBookingFilterProvider);
    // Watch the booking state from the notifier
    final bookingState = ref.watch(bookingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background, // Background color for the screen
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: AppTextStyles.headline2.copyWith(color: AppColors.textPrimary), //
        ),
        backgroundColor: AppColors.cardBackground,
        elevation: 0, 
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs (Active, Pending, Completed)
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Active', 'Pending', 'Completed'].map((status) {
                final isSelected = selectedFilter == status;
                return GestureDetector(
                  onTap: () {
                    // Update the filter provider and load bookings
                    ref.read(selectedBookingFilterProvider.notifier).state = status;
                    _loadBookingsForFilter(status);
                  },
                  child: Column(
                    children: [
                      Text(
                        status,
                        style: AppTextStyles.subtitle.copyWith( //
                          color: isSelected ? AppColors.accent : AppColors.textSecondary, //
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Container(
                          height: 3,
                          width: 60, 
                          decoration: BoxDecoration(
                            color: AppColors.accent, 
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16), 
          Expanded(
            child: bookingState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookingState.error != null
                    ? Center(
                        child: Text(
                          'Error: ${bookingState.error}',
                          style: AppTextStyles.body.copyWith(color: AppColors.accent), //
                          textAlign: TextAlign.center,
                        ),
                      )
                    : bookingState.bookings.isEmpty
                        ? Center(
                            child: Text(
                              'No ${selectedFilter.toLowerCase()} bookings found.',
                              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary), //
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: bookingState.bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookingState.bookings[index];
                              return BookingCard(
                                booking: booking,
                                serviceName: booking.categoryName ?? 'Unknown Service', 
                                serviceProviderName: booking.providerName ?? 'Unknown Provider', 
                                onReschedule: booking.status.toLowerCase() == 'pending' || booking.status.toLowerCase() == 'active'
                                    ? () => _onReschedule(booking)
                                    : null,
                                onCancel: booking.status.toLowerCase() == 'pending' || booking.status.toLowerCase() == 'active'
                                    ? () => _onCancel(booking.id!) 
                                    : null, 
                              );
                            },
                          ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}