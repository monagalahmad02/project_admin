class HallsModel {
  final int? id;
  final String? hallImage;
  final String? name;
  final int? ownerId;
  final String? location;
  final int? capacity;
  final List<dynamic> contact;
  final String? type;
  final dynamic events; // String أو List
  final List<dynamic> payMethods;
  final String? status;
  final double? rate;
  final String? subscriptionExpiresAt;
  final String? createdAt;
  final String? updatedAt;
  final double? reviewsAvgRating;
  final List<dynamic> images;
  final List<dynamic> video;
  final List<dynamic> prices;
  final List<dynamic> reviews;
  final List<dynamic> eventImages;
  final List<dynamic> eventVideos;

  HallsModel({
    this.id,
    this.hallImage,
    this.name,
    this.ownerId,
    this.location,
    this.capacity,
    List<dynamic>? contact,
    this.type,
    this.events,
    List<dynamic>? payMethods,
    this.status,
    this.rate,
    this.subscriptionExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.reviewsAvgRating,
    List<dynamic>? images,
    List<dynamic>? video,
    List<dynamic>? prices,
    List<dynamic>? reviews,
    List<dynamic>? eventImages,
    List<dynamic>? eventVideos,
  })  : contact = contact ?? [],
        payMethods = payMethods ?? [],
        images = images ?? [],
        video = video ?? [],
        prices = prices ?? [],
        reviews = reviews ?? [],
        eventImages = eventImages ?? [],
        eventVideos = eventVideos ?? [];

  factory HallsModel.fromJson(Map<String, dynamic> json) {
    dynamic parsedEvents;
    if (json['events'] is List) {
      parsedEvents = List<String>.from(json['events']);
    } else {
      parsedEvents = json['events']?.toString();
    }

    return HallsModel(
      id: json['id'],
      hallImage: json['hall_image'],
      name: json['name'],
      ownerId: json['owner_id'],
      location: json['location'],
      capacity: json['capacity'],
      contact: json['contact'] != null
          ? List<dynamic>.from(json['contact'])
          : [],
      type: json['type'],
      events: parsedEvents,
      payMethods: json['pay_methods'] != null
          ? List<dynamic>.from(json['pay_methods'])
          : [],
      status: json['status'],
      rate: json['rate'] != null
          ? double.tryParse(json['rate'].toString())
          : null,
      subscriptionExpiresAt: json['subscription_expires_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      reviewsAvgRating: json['reviews_avg_rating'] != null
          ? double.tryParse(json['reviews_avg_rating'].toString())
          : null,
      images: json['images'] != null ? List<dynamic>.from(json['images']) : [],
      video: json['video'] != null ? List<dynamic>.from(json['video']) : [],
      prices: json['prices'] != null ? List<dynamic>.from(json['prices']) : [],
      reviews: json['reviews'] != null ? List<dynamic>.from(json['reviews']) : [],
      eventImages: json['event_images'] != null
          ? List<dynamic>.from(json['event_images'])
          : [],
      eventVideos: json['event_videos'] != null
          ? List<dynamic>.from(json['event_videos'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hall_image': hallImage,
      'name': name,
      'owner_id': ownerId,
      'location': location,
      'capacity': capacity,
      'contact': contact,
      'type': type,
      'events': events,
      'pay_methods': payMethods,
      'status': status,
      'rate': rate,
      'subscription_expires_at': subscriptionExpiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reviews_avg_rating': reviewsAvgRating,
      'images': images,
      'video': video,
      'prices': prices,
      'reviews': reviews,
      'event_images': eventImages,
      'event_videos': eventVideos,
    };
  }
}
