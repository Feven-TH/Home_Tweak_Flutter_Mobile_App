import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'package:frontend/features/bookings/presentation/booking_state.dart';

void main() {
  group('Booking User Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('User can view their bookings', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final userId = 1;

      // Create some bookings for the user
      final bookings = List.generate(
        3,
        (index) => Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: index)),
          status: 'Pending',
        ),
      );

      for (final booking in bookings) {
        await notifier.create(booking);
      }

      // Load user's bookings
      await notifier.loadUserBookings(userId);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 3);
      expect(state.bookings.every((b) => b.userId == userId), true);
    });

    test('User can filter their bookings by status', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final userId = 1;

      // Create bookings with different statuses
      final bookings = [
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now(),
          status: 'Pending',
        ),
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: 1)),
          status: 'Confirmed',
        ),
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: 2)),
          status: 'Completed',
        ),
      ];

      for (final booking in bookings) {
        await notifier.create(booking);
      }

      // Test different status filters
      await notifier.loadUserBookingsByStatus(userId, 'Pending');
      var state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 1);
      expect(state.bookings.first.status, 'Pending');

      await notifier.loadUserBookingsByStatus(userId, 'Confirmed');
      state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 1);
      expect(state.bookings.first.status, 'Confirmed');
    });

    test('User can view booking history', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final userId = 1;

      // Create some past bookings
      final pastBookings = List.generate(
        3,
        (index) => Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().subtract(Duration(days: index + 1)),
          status: 'Completed',
        ),
      );

      for (final booking in pastBookings) {
        await notifier.create(booking);
      }

      // Load user's booking history
      await notifier.loadUserBookingHistory(userId);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 3);
      expect(state.bookings.every((b) => b.status == 'Completed'), true);
    });

    test('User can view upcoming bookings', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final userId = 1;

      // Create some future bookings
      final futureBookings = List.generate(
        3,
        (index) => Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: index + 1)),
          status: 'Confirmed',
        ),
      );

      for (final booking in futureBookings) {
        await notifier.create(booking);
      }

      // Load user's upcoming bookings
      await notifier.loadUserUpcomingBookings(userId);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 3);
      expect(state.bookings.every((b) => b.status == 'Confirmed'), true);
    });

    test('User can view booking statistics', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final userId = 1;

      // Create bookings with different statuses
      final bookings = [
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now(),
          status: 'Pending',
        ),
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: 1)),
          status: 'Confirmed',
        ),
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: 2)),
          status: 'Completed',
        ),
        Booking(
          userId: userId,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: 3)),
          status: 'Cancelled',
        ),
      ];

      for (final booking in bookings) {
        await notifier.create(booking);
      }

      // Load user's booking statistics
      final stats = await notifier.getUserBookingStatistics(userId);
      
      expect(stats['total'], 4);
      expect(stats['pending'], 1);
      expect(stats['confirmed'], 1);
      expect(stats['completed'], 1);
      expect(stats['cancelled'], 1);
    });

    test('User can view provider bookings', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final userId = 1;
      final providerId = 2;

      // Create bookings for different providers
      final bookings = [
        Booking(
          userId: userId,
          providerId: providerId,
          serviceDate: DateTime.now(),
          status: 'Pending',
        ),
        Booking(
          userId: userId,
          providerId: 3,
          serviceDate: DateTime.now().add(Duration(days: 1)),
          status: 'Confirmed',
        ),
      ];

      for (final booking in bookings) {
        await notifier.create(booking);
      }

      // Load user's bookings for specific provider
      await notifier.loadUserProviderBookings(userId, providerId);

      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 1);
      expect(state.bookings.first.providerId, providerId);
    });
  });
} 