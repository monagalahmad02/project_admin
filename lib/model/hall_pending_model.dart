class HallPending {
  final int id;
  final String? hallImage;
  final String name;
  final String location;
  final int capacity;
  final String contact;
  final String type;
  final List<String> events; // ✅ تعديل هنا
  final dynamic payMethods;
  final String status;
  final String? rate;
  final String createdAt;
  final String updatedAt;
  final double? reviewsAvgRating; // ✅ جديد
  final List<HallImage> images;
  final OwnerMini? owner; // ✅ جديد
  final List<dynamic> video;  // ✅ جديد
  final List<dynamic> prices; // ✅ جديد
  final List<dynamic> reviews; // ✅ جديد

  HallPending({
    required this.id,
    this.hallImage,
    required this.name,
    required this.location,
    required this.capacity,
    required this.contact,
    required this.type,
    required this.events,
    this.payMethods,
    required this.status,
    this.rate,
    required this.createdAt,
    required this.updatedAt,
    this.reviewsAvgRating,
    required this.images,
    this.owner,
    required this.video,
    required this.prices,
    required this.reviews,
  });

  factory HallPending.fromJson(Map<String, dynamic> json) {
    return HallPending(
      id: json['id'],
      hallImage: json['hall_image'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      contact: json['contact'],
      type: json['type'],
      events: json['events'] != null
          ? List<String>.from(json['events'].map((e) => e.toString()))
          : [],
      payMethods: json['pay_methods'],
      status: json['status'],
      rate: json['rate'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      reviewsAvgRating: json['reviews_avg_rating'] != null
          ? double.tryParse(json['reviews_avg_rating'].toString())
          : null,
      images: json['images'] != null
          ? List<HallImage>.from(json['images'].map((img) => HallImage.fromJson(img)))
          : [],
      owner: json['owner'] != null ? OwnerMini.fromJson(json['owner']) : null,
      video: json['video'] ?? [],
      prices: json['prices'] ?? [],
      reviews: json['reviews'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hall_image': hallImage,
      'name': name,
      'location': location,
      'capacity': capacity,
      'contact': contact,
      'type': type,
      'events': events,
      'pay_methods': payMethods,
      'status': status,
      'rate': rate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reviews_avg_rating': reviewsAvgRating,
      'images': images.map((img) => img.toJson()).toList(),
      'owner': owner?.toJson(),
      'video': video,
      'prices': prices,
      'reviews': reviews,
    };
  }
}

class HallImage {
  final int id;
  final int hallId;
  final String imagePath;

  HallImage({
    required this.id,
    required this.hallId,
    required this.imagePath,
  });

  factory HallImage.fromJson(Map<String, dynamic> json) {
    return HallImage(
      id: json['id'],
      hallId: json['hall_id'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hall_id': hallId,
      'image_path': imagePath,
    };
  }
}

class OwnerMini {
  final int id;
  final String? photo;

  OwnerMini({
    required this.id,
    this.photo,
  });

  factory OwnerMini.fromJson(Map<String, dynamic> json) {
    return OwnerMini(
      id: json['id'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
    };
  }
}
