// lib/models/org_model.dart

class Org {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String contact;
  final String? imageUrl;
  final int? rating;
  final String createdAt;

  Org({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.contact,
    this.imageUrl,
    this.rating,
    required this.createdAt,
  });

  factory Org.fromJson(Map<String, dynamic> json) {
    return Org(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      contact: json['contact'],
      imageUrl: json['image_url'],
      rating: json['rating'],
      createdAt: json['created_at'],
    );
  }
}