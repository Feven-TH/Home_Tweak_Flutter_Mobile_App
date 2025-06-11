import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'package:frontend/features/bookings/presentation/booking_state.dart';

void main() {
  group('BookingNotifier Unit Tests', () {
    late ProviderContainer container;
    late BookingNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(bookingNotifierProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is correct', () {
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.bookings, isEmpty);
    });

    test('Loading state is set correctly', () async {
      // Start loading
      notifier.setLoading(true);
      expect(container.read(bookingNotifierProvider).isLoading, true);

      // Stop loading
      notifier.setLoading(false);
      expect(container.read(bookingNotifierProvider).isLoading, false);
    });

    test('Error state is set correctly', () {
      const errorMessage = 'Test error message';
      notifier.setError(errorMessage);
      
      final state = container.read(bookingNotifierProvider);
      expect(state.error, errorMessage);
      expect(state.isLoading, false);
    });

    test('Bookings are added correctly', () {
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      notifier.addBooking(booking);
      
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 1);
      expect(state.bookings.first, booking);
    });

    test('Bookings are updated correctly', () {
      // Add initial booking
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);

      // Update booking
      final updatedBooking = booking.copyWith(status: 'Confirmed');
      notifier.updateBooking(updatedBooking);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 1);
      expect(state.bookings.first.status, 'Confirmed');
    });

    test('Bookings are removed correctly', () {
      // Add booking
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);

      // Remove booking
      notifier.removeBooking(booking.id!);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings, isEmpty);
    });

    test('State is cleared correctly', () {
      // Add some data to state
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);
      notifier.setError('Test error');

      // Clear state
      notifier.clearState();

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings, isEmpty);
      expect(state.error, isNull);
      expect(state.isLoading, false);
    });

    test('Booking status validation works correctly', () {
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      // Test valid status transition
      expect(notifier.isValidStatusTransition('Pending', 'Confirmed'), true);
      expect(notifier.isValidStatusTransition('Confirmed', 'Completed'), true);

      // Test invalid status transition
      expect(notifier.isValidStatusTransition('Completed', 'Pending'), false);
      expect(notifier.isValidStatusTransition('Cancelled', 'Confirmed'), false);
    });

    test('Booking date validation works correctly', () {
      final now = DateTime.now();
      final pastDate = now.subtract(Duration(days: 1));
      final futureDate = now.add(Duration(days: 1));
      final farFutureDate = now.add(Duration(days: 366));

      // Test valid dates
      expect(notifier.isValidBookingDate(futureDate), true);

      // Test invalid dates
      expect(notifier.isValidBookingDate(pastDate), false);
      expect(notifier.isValidBookingDate(farFutureDate), false);
    });

    test('Booking ID validation works correctly', () {
      // Test valid IDs
      expect(notifier.isValidBookingId(1), true);
      expect(notifier.isValidBookingId(999), true);

      // Test invalid IDs
      expect(notifier.isValidBookingId(0), false);
      expect(notifier.isValidBookingId(-1), false);
    });

    test('State updates are atomic', () {
      final booking1 = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      final booking2 = Booking(
        userId: 2,
        providerId: 3,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      // Perform multiple state updates
      notifier.addBooking(booking1);
      notifier.setLoading(true);
      notifier.addBooking(booking2);
      notifier.setLoading(false);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 2);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });
  });
} 