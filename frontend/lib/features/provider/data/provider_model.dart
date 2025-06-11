// features/provider/data/provider_model.dart
class ServiceProvider {
  final int id;
  final int userId;
  final int? categoryId; // Changed: Made nullable as it's excluded from 'getProviderById' backend response
  final String? certificate;
  final String? location;
  final String? imageUrl;
  final String phoneNumber;
  final double hourlyRate; 
  final int yearsOfExperience;
  final double? rating;
  final String? serviceDescription;
  final String username;
  final String? category;

  ServiceProvider({
    required this.id,
    required this.userId,
    this.categoryId,
    this.certificate,
    this.location,
    this.imageUrl,
    required this.phoneNumber,
    required this.hourlyRate, // Ensure type matches in constructor
    required this.yearsOfExperience,
    this.rating,
    this.serviceDescription,
    required this.username,
    required this.category,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse a double
    double? parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    // Helper function to safely parse an int
    int? parseInt(dynamic value) {
      if (value is num) {
        return value.toInt();
      } else if (value is String) {
        return int.tryParse(value);
      }
      return null;
    }

    return ServiceProvider(
      id: json['id'] as int,
      userId: json['userId'] as int,
      categoryId: json['categoryId'] as int?,
      certificate: json['certificate'] as String?,
      location: json['location'] as String?,
      imageUrl: json['imageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String, 
      hourlyRate: parseDouble(json['hourlyRate']) ?? 500.0, //  Default to 0.0 if parsing fails
      yearsOfExperience: parseInt(json['yearsOfExperience']) ?? 2, // Default to 2 if parsing fails.
      rating: (json['rating'] as num?)?.toDouble(),
      serviceDescription: json['serviceDescription'] as String?,
      username: json['username'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'categoryId': categoryId,
        'certificate': certificate,
        'location': location,
        'imageUrl': imageUrl,
        'phoneNumber': phoneNumber,
        'hourlyRate': hourlyRate,
        'yearsOfExperience': yearsOfExperience,
        'rating': rating,
        'serviceDescription': serviceDescription,
        'username': username,
        'category': category,
      };
}