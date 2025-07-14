class UserBlockedModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? location;     // أصبحت nullable
  final String? number;       // أصبحت nullable
  final String? photo;
  final String? idImage;
  final String? role;         // أصبحت nullable
  final String? apiToken;
  final String? createdAt;    // أصبحت nullable
  final String? updatedAt;    // أصبحت nullable
  final int isBlocked;

  UserBlockedModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.location,
    this.number,
    this.photo,
    this.idImage,
    this.role,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
    required this.isBlocked,
  });

  factory UserBlockedModel.fromJson(Map<String, dynamic> json) {
    return UserBlockedModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      location: json['location'],
      number: json['number'],
      photo: json['photo'],
      idImage: json['id_image'],
      role: json['role'],
      apiToken: json['api_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isBlocked: json['is_blocked'] ?? 0,
    );
  }
}
