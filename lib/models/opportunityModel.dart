class Opportunity {
  String title;
  String id;
  String? similarity;
  String industry;
  String company;
  String description;
  List<String> requirements;
  List<String>? fieldsOfStudy;
  List<String>? skills;
  String location;
  String company_image;
  String availability;
  List<String> courses;
  String deadline;
  String company_email;
  String opportunity_type;

  Opportunity({
    required this.title,
    required this.industry,
    required this.courses,
    required this.id,
    required this.company_email,
    required this.requirements,
    this.skills,
    this.similarity,
    required this.company,
    required this.description,
    this.fieldsOfStudy,
    required this.company_image,
    required this.availability,
    required this.location,
    required this.deadline,
    required this.opportunity_type,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      title: json['title'],
      courses: json["courses"] == null ? [] : List<String>.from(json["courses"]!.map((x) => x)),
      industry: json['industry'],
      company_email: json['company_email'] ?? "",
      id: json['id'],
      company: json['company'],
      description: json['description'],
      requirements: List<String>.from(json['requirements']),
      fieldsOfStudy: json['field_of_study'] != null ? List<String>.from(json['field_of_study']) : [],
      skills: json['skills'] != null ?List<String>.from(json['skills']) : [],
      location: json['location'],
      company_image: json['company_image'],
      availability: json['availability'],
      deadline: json['deadline'],
      opportunity_type: json['opportunity_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "courses": courses == null ? [] : List<dynamic>.from(courses!.map((x) => x)),
      'title': title,
      'industry': industry,
      'company_email': company_email,
      'id': id,
      'company': company,
      'description': description,
      'requirements': requirements,
      'skills': skills,
      'fieldsOfStudy': fieldsOfStudy,
      'location': location,
      'company_image': company_image,
      'availability': availability,
      'deadline': deadline,
      'opportunity_type': opportunity_type,
    };
  }
}