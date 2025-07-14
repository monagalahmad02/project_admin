class HallPending {
  final int id;
  final String? hallImage;       // ممكن تكون null
  final String name;
  final String location;
  final int capacity;
  final String contact;
  final String type;
  final List<String> events;
  final dynamic payMethods;       // ممكن تكون null أو أي نوع ثاني
  final String status;
  final String? rate;             // ممكن تكون null
  final String createdAt;
  final String updatedAt;
  final List<HallImage> images;
  final int? ownerId;             // ممكن تكون null

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
    required this.images,
    this.ownerId,
  });

  factory HallPending.fromJson(Map<String, dynamic> json) {
    return HallPending(
      id: json['id'],
      hallImage: json['hall_image'],               // ممكن null
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      contact: json['contact'],
      type: json['type'],
      events: json['events'] != null
          ? List<String>.from(json['events'])
          : [],
      payMethods: json['pay_methods'],             // ممكن null
      status: json['status'],
      rate: json['rate'],                           // ممكن null
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      images: json['images'] != null
          ? List<HallImage>.from(json['images'].map((img) => HallImage.fromJson(img)))
          : [],
      ownerId: json['owner_id'],                    // ممكن null
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
      'images': images.map((img) => img.toJson()).toList(),
      'owner_id': ownerId,
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
