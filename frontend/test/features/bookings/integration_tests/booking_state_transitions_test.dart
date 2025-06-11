import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Booking State Transitions Test', () {
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

    test('Update booking status transitions correctly', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // First create a booking
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now().add(Duration(days: 2)),
        status: 'Pending',
      );
      await notifier.create(booking);

      // Update the booking status
      await notifier.updateBookingStatus(booking.id!, 'Confirmed');

      // Verify state changes
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.bookings.any((b) => b.status == 'Confirmed'), true);

      listener.close();
    });

    test('Cancel booking updates state correctly', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // First create a booking
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now().add(Duration(days: 2)),
        status: 'Pending',
      );
      await notifier.create(booking);

      // Cancel the booking
      await notifier.cancelBooking(booking.id!);

      // Verify state changes
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.bookings.any((b) => b.status == 'Cancelled'), true);

      listener.close();
    });

    test('Load bookings with different status filters', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Test loading bookings with different status filters
      await notifier.loadBookings(1, 'Pending');
      var state = container.read(bookingNotifierProvider);
      expect(state.bookings.every((b) => b.status == 'Pending'), true);

      await notifier.loadBookings(1, 'Confirmed');
      state = container.read(bookingNotifierProvider);
      expect(state.bookings.every((b) => b.status == 'Confirmed'), true);

      await notifier.loadBookings(1, 'Completed');
      state = container.read(bookingNotifierProvider);
      expect(state.bookings.every((b) => b.status == 'Completed'), true);

      listener.close();
    });

    test('Handle concurrent booking operations', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Create multiple bookings simultaneously
      final bookings = List.generate(
        3,
        (index) => Booking(
          userId: 1,
          providerId: 2,
          serviceDate: DateTime.now().add(Duration(days: index + 1)),
          status: 'Pending',
        ),
      );

      // Create bookings concurrently
      await Future.wait(bookings.map((booking) => notifier.create(booking)));

      // Verify all bookings were created
      final state = container.read(bookingNotifierProvider);
      expect(state.bookings.length, 3);
      expect(state.error, isNull);

      listener.close();
    });
  });
} 