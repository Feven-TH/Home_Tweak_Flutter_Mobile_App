import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/features/bookings/domain/booking_repository_interface.dart';
import 'package:frontend/features/bookings/domain/booking_usecases/update_booking_status.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late MockBookingRepository mockRepository;
  late UpdateBookingStatus useCase;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = UpdateBookingStatus(mockRepository);
  });

  test('should update booking status', () async {
    const bookingId = 1;
    const newStatus = 'Completed';

    when(mockRepository.updateBookingStatus(bookingId, newStatus))
        .thenAnswer((_) async {});  // <-- Proper Future<void> stub

    await useCase.call(bookingId, newStatus);

    verify(mockRepository.updateBookingStatus(bookingId, newStatus)).called(1);
  });
}
