// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  static const String baseUrl = 'http://localhost:5000'; // backend base

  // Auth
  static const String login = '/users/login';
  static const String signup = '/users/register';
  static String deleteAccount(int id) => '/users/delete/$id';
  static const String forgotPassword = '/users/forgot-password';
  static const String resetPassword = '/users/reset-password';
  static String logout(int id) => '/users/logout/$id';

  // Users
  static String getUserById(int id) => '/users/$id';
  static String updateUser(int id) => '/users/$id';

  // Providers
  static const String createProvider = '/providers';
  static String updateProvider(int id) => '/providers/$id';
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
  static String getBookingsByProvider(int providerId) => '/bookings/provider/$providerId'; //added this  to get the bookings of the provider 
}
