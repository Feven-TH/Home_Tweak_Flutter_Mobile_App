// This test verifies that the RescheduleBooking use case correctly
// delegates the booking rescheduling logic to the repository.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/features/bookings/domain/booking_repository_interface.dart';
import 'package:frontend/features/bookings/domain/booking_usecases/reschedule_booking.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late MockBookingRepository mockRepository;
  late RescheduleBooking useCase;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = RescheduleBooking(mockRepository);
  });

  test(
    'should properly reschedule a booking to the specified new date',
    () async {
      const bookingId = 1;
      final targetDate = DateTime(2025, 6, 10);

      when(
        mockRepository.rescheduleBooking(bookingId, targetDate),
      ).thenAnswer((_) async {});

      await useCase.call(bookingId, targetDate);

      verify(mockRepository.rescheduleBooking(bookingId, targetDate)).called(1);

      expectLater(
        () async => await useCase.call(bookingId, targetDate),
        returnsNormally,
      );
    },
  );
}
