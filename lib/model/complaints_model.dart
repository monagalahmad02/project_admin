class ComplaintsModel {
  final int? id;
  final int? userId;
  final int? hallId;
  final String? complaint;
  final String? createdAt;
  final String? updatedAt;
  final User? user;

  ComplaintsModel({
    this.id,
    this.userId,
    this.hallId,
    this.complaint,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory ComplaintsModel.fromJson(Map<String, dynamic> json) {
    return ComplaintsModel(
      id: json['id'],
      userId: json['user_id'],
      hallId: json['hall_id'],
      complaint: json['complaint'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hall_id': hallId,
      'complaint': complaint,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
    };
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? location;
  final String? number;
  final String? photo;
  final String? idImage;
  final String? role;
  final String? apiToken;
  final String? createdAt;
  final String? updatedAt;
  final int? isBlocked;

  User({
    this.id,
    this.name,
    this.email,
    this.location,
    this.number,
    this.photo,
    this.idImage,
    this.role,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
    this.isBlocked,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      location: json['location'],
      number: json['number'],
      photo: json['photo'],
      idImage: json['id_image'],
      role: json['role'],
      apiToken: json['api_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isBlocked: json['is_blocked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'location': location,
      'number': number,
      'photo': photo,
      'id_image': idImage,
      'role': role,
      'api_token': apiToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_blocked': isBlocked,
    };
  }
}
