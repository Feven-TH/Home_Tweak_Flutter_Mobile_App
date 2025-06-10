class Provider {
  final int id;
  final int userId;
  final int? categoryId; // Changed: Made nullable as it's excluded from 'getProviderById' backend response
  final String? certificate;
  final String? location;
  final String? imageUrl;
  final String phoneNumber;
  final String hourlyRate;
  final int yearsOfExperience;
  final double? rating;
  final String? serviceDescription;
  final String? username; // Added: Field for username from backend
  final String? category; // Added: Field for category name from backend

  Provider({
    required this.id,
    required this.userId,
    this.categoryId, 
    this.certificate,
    this.location,
    this.imageUrl,
    required this.phoneNumber,
    required this.hourlyRate,
    required this.yearsOfExperience,
    this.rating,
    this.serviceDescription,
    this.username, // Added: Parameter for username
    this.category, // Added: Parameter for category
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json['id'] as int,
        userId: json['userId'] as int,
        categoryId: json['categoryId'] as int?, // Changed: Read as nullable int
        certificate: json['certificate'] as String?,
        location: json['location'] as String?,
        imageUrl: json['imageUrl'] as String?,
        phoneNumber: json['phoneNumber'] as String,
        hourlyRate: json['hourlyRate'] as String,
        yearsOfExperience: json['yearsOfExperience'] as int,
        rating: (json['rating'] as num?)?.toDouble(),
        serviceDescription: json['serviceDescription'] as String?,
        username: json['username'] as String?, // Added: Read username from JSON
        category: json['category'] as String?, // Added: Read category from JSON
      );

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
        'username': username, // Added: Include username in toJson
        'category': category, // Added: Include category in toJson
      };
}