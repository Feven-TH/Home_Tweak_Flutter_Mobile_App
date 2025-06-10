import '../../data/booking_model.dart';
import '../../domain/booking_repository_interface.dart';

class CreateBooking {
  final IBookingRepository repository;

  CreateBooking(this.repository);

  Future<Booking> call(Booking booking) {
    return repository.createBooking(booking);
  }
}
