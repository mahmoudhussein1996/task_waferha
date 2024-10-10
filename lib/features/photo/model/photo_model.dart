class Photo {
  final String title;
  final String thumbnailUrl;
  final int albumId;

  Photo({required this.title, required this.thumbnailUrl, required this.albumId});

  // Factory method to create a Photo instance from a JSON map.
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      albumId: json['albumId'],
    );
  }
}