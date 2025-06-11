import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Error Handling Test', () {
    late ProviderContainer container;

    setUpAll(() {
      HttpOverrides.global = null;
    });

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Handle invalid booking creation', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Try to create a booking with invalid data
      final invalidBooking = Booking(
        userId: -1, // Invalid user ID
        providerId: 0, // Invalid provider ID
        serviceDate: DateTime.now().subtract(Duration(days: 1)), // Past date
        status: 'InvalidStatus',
      );

      await notifier.create(invalidBooking);

      // Verify error state
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);
      expect(state.bookings.isEmpty, true);

      listener.close();
    });

    test('Handle booking update with invalid ID', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Try to update a non-existent booking
      await notifier.updateBookingStatus(999999, 'Confirmed');

      // Verify error state
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);

      listener.close();
    });

    test('Handle invalid date range bookings', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Try to create bookings with invalid date ranges
      final invalidDateBooking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now().add(Duration(days: 365)), // Too far in future
        status: 'Pending',
      );

      await notifier.create(invalidDateBooking);

      // Verify error state
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);

      listener.close();
    });

    test('Handle duplicate booking creation', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Create initial booking
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now().add(Duration(days: 2)),
        status: 'Pending',
      );
      await notifier.create(booking);

      // Try to create the same booking again
      await notifier.create(booking);

      // Verify error state
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);
      expect(state.bookings.length, 1); // Should only have one booking

      listener.close();
    });

    test('Handle network timeout scenarios', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Simulate a network timeout by using an invalid endpoint
      await notifier.loadBookings(1, 'TimeoutTest');

      // Verify error state
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);
      expect(state.isLoading, false);

      listener.close();
    });

    test('Handle invalid status transitions', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Create a booking
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now().add(Duration(days: 2)),
        status: 'Pending',
      );
      await notifier.create(booking);

      // Try invalid status transition
      await notifier.updateBookingStatus(booking.id!, 'InvalidStatus');

      // Verify error state
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);
      expect(state.bookings.first.status, 'Pending'); // Status should remain unchanged

      listener.close();
    });
  });
} 