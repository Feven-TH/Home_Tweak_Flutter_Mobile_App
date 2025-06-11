import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/dio_client.dart';
import 'package:frontend/features/bookings/data/booking_repository.dart';
import 'package:frontend/features/bookings/data/booking_model.dart';

void main() {
  late BookingRepositoryImpl bookingRepository;
  late Dio dio;

  setUp(() {
    dio = DioClient.createDio(); // your DioClient should be correctly defined
    bookingRepository = BookingRepositoryImpl(dio);
  });

  test('Fetch bookings by user and status returns non-empty list', () async {
    final bookings = await bookingRepository.getBookingsByUserAndStatus(1, 'Pending');
    expect(bookings, isA<List<Booking>>());
    expect(bookings, isNotEmpty); // or use isEmpty if expecting none
  });

  test('Create a booking successfully', () async {
    final testBooking = Booking(
  id: 0, 
  userId: 1,
  providerId: 1,
  serviceDate: DateTime.now().add(Duration(days: 1)),
  // bookingDate: DateTime.now(),
  status: 'Pending',
);

    final createdBooking = await bookingRepository.createBooking(testBooking);
    expect(createdBooking, isA<Booking>());
    expect(createdBooking.userId, equals(1));
  });
}
