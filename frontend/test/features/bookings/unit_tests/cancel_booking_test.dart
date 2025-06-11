// This test ensures that the CancelBooking use case properly
// delegates the cancellation logic to the repository layer using a mock.

// Import necessary testing libraries
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// import 'package:frontend/features/bookings/domain/booking_repository_interface.dart';
import 'package:frontend/features/bookings/domain/booking_usecases/cancel_bookings.dart';
// Import the generated mock file
import '../../../../test/mocks.mocks.dart'; // Adjust path if needed

void main() {
  // Use the generated mock class: MockIBookingRepository
  late MockIBookingRepository mockRepository;
  late CancelBooking useCase;

  setUp(() {
    mockRepository = MockIBookingRepository(); // Instantiate the generated mock
    useCase = CancelBooking(mockRepository);
  });

  test('should successfully cancel a booking by ID', () async {
    const idToCancel = 1;

    when(
      mockRepository.cancelBooking(any),
    ).thenAnswer((_) async {}); // Simulate successful cancellation

    await useCase.call(idToCancel);

    verify(mockRepository.cancelBooking(idToCancel)).called(1);

    expectLater(() async => await useCase.call(idToCancel), returnsNormally);
  });
}
