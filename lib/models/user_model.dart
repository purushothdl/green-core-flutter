// lib/models/user_model.dart
class User {
  final String? id; 
  final String name;
  final String email;
  final String? password; 
  final String phone;
  final String address;
  final String state;
  final String? imageUrl; 
  final String? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.password, 
    required this.phone,
    required this.address,
    required this.state,
    this.imageUrl,
    this.createdAt,
  });

  // Convert User object to JSON for API request (e.g., register)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password, 
      'phone': phone,
      'address': address,
      'state': state,
    };
  }

  // Convert JSON to User object (e.g., /me response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      address: json['address'] ?? 'N/A',
      state: json['state'] ?? 'N/A',
      imageUrl: json['image_url'],
      createdAt: json['created_at'] ?? 'N/A'
    );
  }
}