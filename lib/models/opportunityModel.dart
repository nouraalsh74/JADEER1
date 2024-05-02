class Opportunity {
  String title;
  String id;
  String industry;
  String company;
  String description;
  List<String> requirements;
  String location;
  String company_image;
  String availability;
  String deadline;
  String company_email;
  String opportunity_type;

  Opportunity({
    required this.title,
    required this.industry,
    required this.id,
    required this.company_email,
    required this.company,
    required this.description,
    required this.requirements,
    required this.company_image,
    required this.availability,
    required this.location,
    required this.deadline,
    required this.opportunity_type,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      title: json['title'],
      industry: json['industry'],
      company_email: json['company_email'] ?? "",
      id: json['id'],
      company: json['company'],
      description: json['description'],
      requirements: List<String>.from(json['requirements']),
      location: json['location'],
      company_image: json['company_image'],
      availability: json['availability'],
      deadline: json['deadline'],
      opportunity_type: json['opportunity_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'industry': industry,
      'company_email': company_email,
      'id': id,
      'company': company,
      'description': description,
      'requirements': requirements,
      'location': location,
      'company_image': company_image,
      'availability': availability,
      'deadline': deadline,
      'opportunity_type': opportunity_type,
    };
  }
}