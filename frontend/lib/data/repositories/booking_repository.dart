import 'package:dio/dio.dart';
import '../../models/booking_model.dart';


class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);


  /// Fetch bookings for a specific user filtered by status
 
  Future<List<Booking>> getBookingsByUserAndStatus(int userId, String status) async {
    try {
      final response = await _dio.get('/bookings/user/$userId/$status');
      final data = response.data as List;
      return data.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by user and status: $e');
    }
  }

  /// ✅ Create a new booking
  Future<Booking> createBooking(Booking booking) async {
    try {
      final response = await _dio.post('/bookings', data: booking.toJson());
      return Booking.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// ✅ Cancel a booking by ID
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _dio.put('/bookings/$bookingId/cancel');
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// ✅ Reschedule an existing booking
  Future<void> rescheduleBooking(int bookingId, DateTime newDate) async {
    try {
      await _dio.patch(
        '/bookings/reschedule/$bookingId',
        data: {'serviceDate': newDate.toIso8601String()},
      );
    } catch (e) {
      throw Exception('Failed to reschedule booking: $e');
    }
  }

  /// ✅ Update status (e.g., to 'Completed', 'Cancelled')
  Future<void> updateBookingStatus(int bookingId, String status) async {
    try {
      await _dio.put(
        '/bookings/$bookingId/status',
        data: {'status': status},
      );
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }
}
