import '../../data/booking_model.dart';
import '../../domain/booking_repository_interface.dart';

class GetBookingsByUserAndStatus {
  final IBookingRepository repository;

  GetBookingsByUserAndStatus(this.repository);

  Future<List<Booking>> call(int userId, String status) {
    return repository.getBookingsByUserAndStatus(userId, status);
  }
}
