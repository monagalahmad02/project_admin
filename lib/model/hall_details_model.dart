class HallsDetailsModel {
  final int id;
  final String? name;
  final int ownerId;
  final int capacity;
  final String? location;
  final String? contact;
  final String? type;
  final String? hallImage;
  final List<dynamic>? prices;  // <-- هنا
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? events;
  final List<HallImage>? images;
  final Owner? owner;

  HallsDetailsModel({
    required this.id,
    this.name,
    required this.ownerId,
    required this.capacity,
    this.location,
    this.contact,
    this.type,
    this.hallImage,
    this.prices,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.events,
    this.images,
    this.owner,
  });

  factory HallsDetailsModel.fromJson(Map<String, dynamic> json) {
    return HallsDetailsModel(
      id: json['id'],
      name: json['name'] ?? 'غير متوفر',
      ownerId: json['owner_id'],
      capacity: json['capacity'],
      location: json['location'] ?? 'غير متوفر',
      contact: json['contact'],
      type: json['type'],
      hallImage: json['hall_image'],
      prices: json['prices'] != null
          ? List<dynamic>.from(json['prices'])
          : [],
      status: json['status'] ?? 'غير متوفر',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      events: json['events'] != null
          ? (json['events'] is List
          ? List<String>.from(json['events'])
          : (json['events'] as String).split(','))
          : [],
      images: json['images'] != null
          ? List<HallImage>.from(
          json['images'].map((img) => HallImage.fromJson(img)))
          : [],
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
    );
  }
}

class Owner {
  final int id;
  final String? photo;

  Owner({
    required this.id,
    this.photo,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
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
}
