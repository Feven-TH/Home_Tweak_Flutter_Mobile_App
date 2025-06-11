import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
// import 'package:frontend/features/bookings/presentation/booking_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Feature Integration Test', () {
    late ProviderContainer container;

    setUpAll(() {
      HttpOverrides.global = null; // Allows real HTTP requests
    });

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Load bookings updates state correctly', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Expect initial state
      expect(container.read(bookingNotifierProvider).isLoading, false);
      expect(container.read(bookingNotifierProvider).error, isNull);

      // Trigger API call
      await notifier.loadBookings(1, 'Pending');

      // Verify state changes
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.bookings.isNotEmpty, true);
      expect(state.error, isNull);

      listener.close(); // Clean up listener
    });

    test('Create booking updates state correctly', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now().add(Duration(days: 2)),
        status: 'Pending',
      );

      // Trigger API call
      await notifier.create(booking);

      // Verify state changes
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      listener.close(); // Clean up listener
    });

    test('Load bookings handles errors correctly', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);
      final listener = container.listen(bookingNotifierProvider, (previous, next) {});

      // Simulate an API failure by using an invalid user ID
      await notifier.loadBookings(-999, 'InvalidStatus');

      // Verify state changes
      final state = container.read(bookingNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNotNull); // Ensure error is set

      listener.close(); // Clean up listener
    });
  });
}
