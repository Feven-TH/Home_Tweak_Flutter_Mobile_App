import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Feature Integration Test', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Load bookings by user and status - success', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);

      await notifier.loadBookings(1, 'Pending'); 

      final state = container.read(bookingNotifierProvider);

      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.bookings, isA<List<Booking>>());
    });

    test('Create booking - success', () async {
      final notifier = container.read(bookingNotifierProvider.notifier);

      final booking = Booking(
        userId: 1,
        providerId: 2,
        // serviceType: 'Plumbing',
        serviceDate: DateTime.now().add(Duration(days: 2)),
        status: 'Pending',
      );

      await notifier.create(booking);

      final state = container.read(bookingNotifierProvider);

      expect(state.isLoading, false);
      expect(state.error, isNull);
    });
    setUpAll(() {
  HttpOverrides.global = null; // Allows real HTTP requests
});
  });
}
