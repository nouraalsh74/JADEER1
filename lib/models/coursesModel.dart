class Courses {
  String title;
  String image;
  String source;
  String id;

  Courses({
    required this.title,
    required this.image,
    required this.id,
    required this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'industry': image,
      'id': id,
      'company': source,
    };
  }
}