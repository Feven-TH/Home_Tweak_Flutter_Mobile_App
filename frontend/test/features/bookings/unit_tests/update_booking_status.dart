// This test ensures that the booking status is updated correctly
// using the UpdateBookingStatus use case with a mocked repository.

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

  test('should successfully update the status of a booking', () async {
    const bookingId = 1;
    const statusToUpdate = 'Completed';

    when(
      mockRepository.updateBookingStatus(bookingId, statusToUpdate),
    ).thenAnswer((_) async {});

    await useCase.call(bookingId, statusToUpdate);

    verify(
      mockRepository.updateBookingStatus(bookingId, statusToUpdate),
    ).called(1);

    expectLater(
      () async => await useCase.call(bookingId, statusToUpdate),
      returnsNormally,
    );
  });
}
