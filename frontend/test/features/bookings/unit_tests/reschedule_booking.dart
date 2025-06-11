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

  test('should reschedule booking to new date', () async {
    const bookingId = 1;
    final newDate = DateTime(2025, 6, 10);

    when(mockRepository.rescheduleBooking(bookingId, newDate))
        .thenAnswer((_) async {});  // <-- Proper Future<void> stub

    await useCase.call(bookingId, newDate);

    verify(mockRepository.rescheduleBooking(bookingId, newDate)).called(1);
  });
}
