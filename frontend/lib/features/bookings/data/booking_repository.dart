import 'package:dio/dio.dart';
import 'booking_model.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../domain/booking_repository_interface.dart';

class BookingRepositoryImpl implements IBookingRepository {
  final Dio _dio;

  BookingRepositoryImpl(this._dio);

  @override
  Future<List<Booking>> getBookingsByUserAndStatus(int userId, String status) async {
    try {
      final response = await _dio.get(ApiEndpoints.getBookingsByUserAndStatus(userId, status));
      final data = response.data as List;
      return data.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by user and status: $e');
    }
  }

@override
Future<Booking> createBooking(Booking booking) async {
  try {
    final response = await _dio.post(ApiEndpoints.createBooking, data: booking.toJson());
    return Booking.fromJson(response.data['booking']); 
  } catch (e) {
    throw Exception('Failed to create booking: $e');
  }
}

  @override
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _dio.put(ApiEndpoints.cancelBooking(bookingId));
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  @override
  Future<void> rescheduleBooking(int bookingId, DateTime newDate) async {
    try {
      await _dio.patch(
        ApiEndpoints.rescheduleBooking(bookingId),
        data: {'serviceDate': newDate.toIso8601String()},
      );
    } catch (e) {
      throw Exception('Failed to reschedule booking: $e');
    }
  }

  @override
  Future<void> updateBookingStatus(int bookingId, String status) async {
    try {
      await _dio.put(
        ApiEndpoints.updateBookingStatus(bookingId),
        data: {'status': status},
      );
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }
}
