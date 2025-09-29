class GalleryItem {
  final String id;
  final String type;
  final String url;
  final String thumbnail;
  final String title;
  final DateTime uploadedAt;

  GalleryItem({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnail,
    required this.title,
    required this.uploadedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
      'title': title,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'],
      type: json['type'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}
