// This test verifies that the CreateBooking use case correctly passes a booking
// object to the repository and returns the created booking.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/features/bookings/domain/booking_repository_interface.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'package:frontend/features/bookings/domain/booking_usecases/create_bookings.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late MockBookingRepository mockRepository;
  late CreateBooking useCase;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CreateBooking(mockRepository);
  });

  test(
    'should successfully create a new booking and return the created instance',
    () async {
      final mockBooking = Booking(
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Pending',
      );

      when(
        mockRepository.createBooking(mockBooking),
      ).thenAnswer((_) async => mockBooking);

      final result = await useCase.call(mockBooking);

      expect(result, mockBooking);
      verify(mockRepository.createBooking(mockBooking)).called(1);

      expectLater(() async => await useCase.call(mockBooking), returnsNormally);
    },
  );
}
