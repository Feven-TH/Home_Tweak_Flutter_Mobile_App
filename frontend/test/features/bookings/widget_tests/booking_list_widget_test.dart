import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/bookings/presentation/widgets/booking_list.dart';
import 'package:frontend/features/bookings/presentation/booking_provider.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';

void main() {
  group('BookingList Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Shows loading indicator when loading', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      notifier.setLoading(true);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows error message when error occurs', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      notifier.setError('Test error message');

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Assert
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('Shows empty state when no bookings', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      notifier.clearState();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Assert
      expect(find.text('No bookings found'), findsOneWidget);
    });

    testWidgets('Shows booking items when bookings exist', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('Handles booking status change', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Find and tap the status change button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Select new status
      await tester.tap(find.text('Confirmed'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('Handles booking cancellation', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Find and tap the cancel button
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      // Confirm cancellation
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('Shows booking details on tap', (WidgetTester tester) async {
      // Arrange
      final notifier = container.read(bookingNotifierProvider.notifier);
      final booking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );
      notifier.addBooking(booking);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: BookingList(),
          ),
        ),
      );

      // Tap on booking item
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Booking Details'), findsOneWidget);
    });
  });
} 