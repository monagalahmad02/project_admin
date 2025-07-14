class HallsModel {
  final int id;
  final String hallImage;
  final String name;
  final int ownerId;
  final String location;
  final int capacity;
  final String contact;
  final String type;
  final List<String> events;
  final String? payMethods;
  final String status;
  final String rate;
  final String createdAt;
  final String updatedAt;
  final dynamic reviewsAvgRating;
  final List<ImageModel> images;
  final List<VideoModel> video;
  final bool isSubscribe; // جديد

  HallsModel({
    required this.id,
    required this.hallImage,
    required this.name,
    required this.ownerId,
    required this.location,
    required this.capacity,
    required this.contact,
    required this.type,
    required this.events,
    required this.payMethods,
    required this.status,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
    required this.reviewsAvgRating,
    required this.images,
    required this.video,
    required this.isSubscribe, // جديد
  });

  factory HallsModel.fromJson(Map<String, dynamic> json) {
    return HallsModel(
      id: json['id'] ?? 0,
      hallImage: json['hall_image'] ?? '',
      name: json['name'] ?? '',
      ownerId: json['owner_id'] ?? 0,
      location: json['location'] ?? '',
      capacity: json['capacity'] ?? 0,
      contact: json['contact'] ?? '',
      type: json['type'] ?? '',
      events: json['events'] is List
          ? List<String>.from(json['events'])
          : (json['events'] != null
          ? (json['events'] as String).split(',')
          : []),
      payMethods: json['pay_methods'],
      status: json['status'] ?? '',
      rate: json['rate'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      reviewsAvgRating: json['reviews_avg_rating'],
      images: (json['images'] as List?)
          ?.map((img) => ImageModel.fromJson(img))
          .toList() ??
          [],
      video: (json['video'] as List?)
          ?.map((vid) => VideoModel.fromJson(vid))
          .toList() ??
          [],
      isSubscribe: json['is_subscribe'] == true,
    );
  }
}


class ImageModel {
  final int id;
  final int hallId;
  final String imagePath;
  final String createdAt;
  final String updatedAt;

  ImageModel({
    required this.id,
    required this.hallId,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      hallId: json['hall_id'] ?? 0,
      imagePath: json['image_path'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}



class VideoModel {
  final int id;
  final int hallId;
  final String videoPath;
  final String createdAt;
  final String updatedAt;

  VideoModel({
    required this.id,
    required this.hallId,
    required this.videoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      hallId: json['hall_id'] ?? 0,
      videoPath: json['video_path'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

