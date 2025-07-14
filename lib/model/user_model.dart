class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String location;
  final String number;
  final String? photo;
  final String? idImage;
  final String role;
  final String? apiToken;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.location,
    required this.number,
    this.photo,
    this.idImage,
    required this.role,
    this.apiToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      location: json['location'],
      number: json['number'],
      photo: json['photo'],
      idImage: json['id_image'],
      role: json['role'],
      apiToken: json['api_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'location': location,
      'number': number,
      'photo': photo,
      'id_image': idImage,
      'role': role,
      'api_token': apiToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
