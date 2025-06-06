class Provider {
  final int id;
  final int userId;
  final int categoryId;
  final String? certificate;
  final String? location;
  final String? imageUrl;
  final String phoneNumber;
  final String hourlyRate;
  final int yearsOfExperience;
  final double? rating;
  final String? serviceDescription;

  Provider({
    required this.id,
    required this.userId,
    required this.categoryId,
    this.certificate,
    this.location,
    this.imageUrl,
    required this.phoneNumber,
    required this.hourlyRate,
    required this.yearsOfExperience,
    this.rating,
    this.serviceDescription,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json['id'],
        userId: json['userId'],
        categoryId: json['categoryId'],
        certificate: json['certificate'],
        location: json['location'],
        imageUrl: json['imageUrl'],
        phoneNumber: json['phoneNumber'],
        hourlyRate: json['hourlyRate'],
        yearsOfExperience: json['yearsOfExperience'],
        rating: (json['rating'] as num?)?.toDouble(),
        serviceDescription: json['serviceDescription'],
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
      };
}
