import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'package:frontend/features/bookings/presentation/booking_state.dart';

void main() {
  group('BookingProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Provider initializes with correct state', () {
      final state = container.read(bookingNotifierProvider);
      expect(state, isA<BookingState>());
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.bookings, isEmpty);
    });

    test('Provider updates state when loading bookings', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      
      // Start loading
      await notifier.loadBookings(1, 'Pending');
      
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.bookings, isNotEmpty);
    });

    test('Provider handles booking creation', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      await notifier.create(booking);
      
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 1);
      expect(state.bookings.first, booking);
    });

    test('Provider handles booking updates', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      await notifier.create(booking);
      await notifier.updateBookingStatus(booking.id!, 'Confirmed');
      
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.first.status, 'Confirmed');
    });

    test('Provider handles booking cancellation', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      await notifier.create(booking);
      await notifier.cancelBooking(booking.id!);
      
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.first.status, 'Cancelled');
    });

    test('Provider handles error states', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      
      // Simulate error
      await notifier.loadBookings(-1, 'InvalidStatus');
      
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNotNull);
      expect(state.isLoading, false);
    });

    test('Provider maintains state consistency', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      
      // Create multiple bookings
      final bookings = List.generate(
        3,
        (index) => Booking(
          userId: 1,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: index)),
          status: 'Pending',
        ),
      );

      for (final booking in bookings) {
        await notifier.create(booking);
      }
      
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 3);
      expect(state.error, isNull);
      expect(state.isLoading, false);
    });

    test('Provider handles concurrent operations', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      // Perform multiple operations concurrently
      await Future.wait([
        notifier.create(booking),
        notifier.loadBookings(1, 'Pending'),
        notifier.updateBookingStatus(booking.id!, 'Confirmed'),
      ]);
      
      final state = container.read(bookingNotifierProvider);
      expect(state.error, isNull);
      expect(state.isLoading, false);
    });

    test('Provider handles state reset', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      await notifier.create(booking);
      notifier.clearState();
      
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings, isEmpty);
      expect(state.error, isNull);
      expect(state.isLoading, false);
    });
  });
} 