import 'package:flutter_application_2/models/userProfileModel.dart';

import 'opportunityModel.dart';

class MyAppliedOpportunity {
  String id ;
  String? cvPath;
  List<Education>? education;
  String? dateOfBirth;
  String? status;
  String? lastName;
  Experience? experience;
  List<String>? skills;
  String? password;
  List<LicensesOrCertification>? licensesOrCertifications;
  String? userId;
  String? phoneNumber;
  List<String>? interests;
  String? firstName;
  String? applyOpportunityID;
  String? email;
  String? countryId;
  String? cityId;
  Opportunity? opportunity;
  MyAppliedOpportunity({
    required this.id,
    this.cvPath,
    this.education,
    this.dateOfBirth,
    this.lastName,
    this.applyOpportunityID,
    this.experience,
    this.skills,
    this.password,
    this.status,
    this.licensesOrCertifications,
    this.userId,
    this.phoneNumber,
    this.interests,
    this.firstName,
    this.email,
    this.countryId,
    this.cityId,
    this.opportunity,
  });

  factory MyAppliedOpportunity.fromJson(Map<String, dynamic> json) {
    return MyAppliedOpportunity(
      id: json['ID'] ?? '',
      cvPath: json['cv_path'],
      applyOpportunityID: json['apply_id'],
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => Education.fromJson(e))
          .toList(),
      dateOfBirth: json['date_of_birth'],
      lastName: json['last_name'],
      status: json['status'],
      experience: json['experience'] != null
          ? Experience.fromJson(json['experience'])
          : null,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      licensesOrCertifications: (json['licenses_or_certifications'] as List<dynamic>?)
          ?.map((e) => LicensesOrCertification.fromJson(e))
          .toList(),
      userId: json['user_id'],
      phoneNumber: json['phone_number'],
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      firstName: json['first_name'],
      email: json['email'],
      countryId: json['country_id'],
      cityId: json['city_id'],
      opportunity: json['opportunity'] != null
          ? Opportunity.fromJson(json['opportunity'])
          : null,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      if(cvPath != null)"cv_path": cvPath,
      if(education != null)"education": education == null ? [] : List<dynamic>.from(education!.map((x) => x.toJson())),
      if(dateOfBirth != null)"date_of_birth": dateOfBirth,
      if(lastName != null) "last_name": lastName,
      if(experience != null)"experience": experience?.toJson(),
      if(skills != null) "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
      if(licensesOrCertifications != null) "licenses_or_certifications": licensesOrCertifications == null ? [] : List<dynamic>.from(licensesOrCertifications!.map((x) => x.toJson())),
      if(userId != null) "user_id": userId,
      if(phoneNumber != null) "phone_number": phoneNumber,
      if(firstName != null)"first_name": firstName,
      if(email != null) "email": email,
      if(countryId != null)"country_id": countryId,
      if(cityId != null) "city_id": cityId,
      if(opportunity != null) 'opportunity': opportunity,
    };
  }
}