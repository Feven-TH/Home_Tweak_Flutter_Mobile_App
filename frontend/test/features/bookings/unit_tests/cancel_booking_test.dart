import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// import 'package:frontend/features/bookings/domain/booking_repository_interface.dart';
import 'package:frontend/features/bookings/domain/booking_usecases/cancel_bookings.dart';
// Import the generated mock file
import '../../../../test/mocks.mocks.dart'; // Adjust path if your mocks.mocks.dart is in a different location

// Remove the manual MockBookingRepository class as it's now generated
// class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  // Use the generated mock class: MockIBookingRepository
  late MockIBookingRepository mockRepository;
  late CancelBooking useCase;

  setUp(() {
    mockRepository = MockIBookingRepository(); // Instantiate the generated mock
    useCase = CancelBooking(mockRepository);
  });

  test('should cancel booking', () async {
    const bookingId = 1;

    // Use 'any' for the argument to ensure the mock matches regardless of instance
    when(mockRepository.cancelBooking(any))
        .thenAnswer((_) async {}); // Proper Future<void> stub

    await useCase.call(bookingId);

    // For verification, you can use the exact value or `any`
    verify(mockRepository.cancelBooking(bookingId)).called(1);
  });
}
