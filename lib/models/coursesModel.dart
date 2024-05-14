class Courses {
  String name;
  String image;
  String link;
  String id;

  Courses({
    required this.name,
    required this.image,
    required this.id,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'id': id,
      'link': link,
    };
  }
  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
    image: json["image"],
    link: json["link"],
    name: json["name"],
    id: json["id"],
  );
}