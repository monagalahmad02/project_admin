class OwnerModel {
  final int id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? location;
  final String? number;
  final String? photo;
  final String? idImage;
  final String? role;
  final String? apiToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OwnerModel({
    required this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.location,
    this.number,
    this.photo,
    this.idImage,
    this.role,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.tryParse(json['email_verified_at']) : null,
      location: json['location'],
      number: json['number'],
      photo: json['photo'],
      idImage: json['id_image'],
      role: json['role'],
      apiToken: json['api_token'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'location': location,
      'number': number,
      'photo': photo,
      'id_image': idImage,
      'role': role,
      'api_token': apiToken,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
