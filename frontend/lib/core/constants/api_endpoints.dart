// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  static const String baseUrl = 'http://localhost:5000'; // backend base

  // Auth
  static const String login = '/users/login';
  static const String signup = '/users/register';
  static const String deleteAccount = '/users/delete';
  static const String forgotPassword = '/users/forgot-password';
  static const String resetPassword = '/users/reset-password';
  static const String logout = '/users/logout';

  // Users
  static String getUserById(int id) => '/users/$id';

  // Providers
  static const String createProvider = '/';
  static const String getAllProviders = '/providers';
  static String getProvidersByCategory(int categoryId) => '/providers/category/$categoryId';
  static const String searchProvidersByName = '$baseUrl/providers/search';
  static String getProviderById(int providerId) => '/providers/$providerId';

  // Categories
  static const String getAllCategories = '/categories';

  // Bookings
  static const String createBooking = '/bookings';
  static String getBookingsByUserAndStatus(int userId, String status) => '/bookings/user/$userId/$status';
  static String cancelBooking(int bookingId) => '/bookings/$bookingId/cancel';
  static String rescheduleBooking(int bookingId) => '/bookings/reschedule/$bookingId';
  static String updateBookingStatus(int bookingId) => '/bookings/$bookingId/status';
}
