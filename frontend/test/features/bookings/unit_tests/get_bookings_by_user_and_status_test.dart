import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/features/bookings/domain/booking_repository_interface.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';
import 'package:frontend/features/bookings/domain/booking_usecases/get_bookings.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late MockBookingRepository mockRepository;
  late GetBookingsByUserAndStatus useCase;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetBookingsByUserAndStatus(mockRepository);
  });

  test('should return list of bookings by user and status', () async {
    final mockBookings = [
      Booking(
        id: 1,
        userId: 1,
        providerId: 2,
        serviceDate: DateTime.now(),
        status: 'Confirmed',
      ),
    ];

    when(mockRepository.getBookingsByUserAndStatus(1, 'Confirmed'))
    .thenAnswer((_) async => mockBookings); // <-- This is the fix!
    final result = await useCase.call(1, 'Confirmed');

    expect(result, mockBookings);
    verify(mockRepository.getBookingsByUserAndStatus(1, 'Confirmed')).called(1);
  });
}
