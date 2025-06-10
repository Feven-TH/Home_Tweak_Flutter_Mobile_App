import '../../domain/booking_repository_interface.dart';

class RescheduleBooking {
  final IBookingRepository repository;

  RescheduleBooking(this.repository);

  Future<void> call(int bookingId, DateTime newDate) {
    return repository.rescheduleBooking(bookingId, newDate);
  }
}
