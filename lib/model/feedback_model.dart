class FeedbackModel {
  final List<Review> reviews;
  final double averageRating;

  FeedbackModel({
    required this.reviews,
    required this.averageRating,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      reviews: (json['reviews'] as List)
          .map((e) => Review.fromJson(e))
          .toList(),
      averageRating: (json['average_rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'average_rating': averageRating,
    };
  }
}

class Review {
  final int id;
  final int userId;
  final int hallId;
  final int rating;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final User user;

  Review({
    required this.id,
    required this.userId,
    required this.hallId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      hallId: json['hall_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hall_id': hallId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String location;
  final String number;
  final String photo;
  final String? idImage;
  final String role;
  final String apiToken;
  final String createdAt;
  final String updatedAt;
  final int isBlocked;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.location,
    required this.number,
    required this.photo,
    this.idImage,
    required this.role,
    required this.apiToken,
    required this.createdAt,
    required this.updatedAt,
    required this.isBlocked,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      isBlocked: json['is_blocked'],
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
      'is_blocked': isBlocked,
    };
  }
}
