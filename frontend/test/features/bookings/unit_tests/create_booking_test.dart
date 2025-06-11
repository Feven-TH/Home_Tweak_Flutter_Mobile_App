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

  test('should create booking and return it', () async {
    final booking = Booking(
      userId: 1,
      providerId: 2,
      serviceDate: DateTime.now(),
      status: 'Pending',
    );

    when(mockRepository.createBooking(booking))
    .thenAnswer((_) async => booking); // <-- This is the fix!

    final result = await useCase.call(booking);

    expect(result, booking);
    verify(mockRepository.createBooking(booking)).called(1);
  });
}
