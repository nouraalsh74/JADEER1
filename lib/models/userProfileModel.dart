// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  String? cvPath;
  List<Education>? education;
  String? dateOfBirth;
  String? lastName;
  Experience? experience;
  List<String>? skills;
  String? password;
  List<LicensesOrCertification>? licensesOrCertifications;
  String? userId;
  String? phoneNumber;
  String? id;
  List<String>? interests;
  String? firstName;
  String? email;
  String? countryId;
  String? cityId;

  UserProfile({
    this.cvPath,
    this.education,
    this.dateOfBirth,
    this.lastName,
    this.experience,
    this.skills,
    this.password,
    this.licensesOrCertifications,
    this.userId,
    this.phoneNumber,
    this.id,
    this.interests,
    this.firstName,
    this.email,
    this.countryId,
    this.cityId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    cvPath: json["cv_path"],
    education: json["education"] == null ? [] : List<Education>.from(json["education"]!.map((x) => Education.fromJson(x))),
    dateOfBirth: json["date_of_birth"],
    lastName: json["last_name"],
    experience: json["experience"] == null ? null : Experience.fromJson(json["experience"]),
    skills: json["skills"] == null ? [] : List<String>.from(json["skills"]!.map((x) => x)),
    password: json["password"],
    licensesOrCertifications: json["licenses_or_certifications"] == null ? [] : List<LicensesOrCertification>.from(json["licenses_or_certifications"]!.map((x) => LicensesOrCertification.fromJson(x))),
    userId: json["user_id"],
    phoneNumber: json["phone_number"],
    id: json["ID"],
    interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
    firstName: json["first_name"],
    email: json["email"],
    countryId: json["country_id"],
    cityId: json["city_id"],
  );

  Map<String, dynamic> toJson() => {
    if(cvPath != null)"cv_path": cvPath,
    if(education != null)"education": education == null ? [] : List<dynamic>.from(education!.map((x) => x.toJson())),
    if(dateOfBirth != null)"date_of_birth": dateOfBirth,
    if(lastName != null) "last_name": lastName,
    if(experience != null)"experience": experience?.toJson(),
    if(skills != null) "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    if(password != null) "password": password,
    if(licensesOrCertifications != null) "licenses_or_certifications": licensesOrCertifications == null ? [] : List<dynamic>.from(licensesOrCertifications!.map((x) => x.toJson())),
    if(userId != null) "user_id": userId,
    if(phoneNumber != null) "phone_number": phoneNumber,
    if(id != null) "ID": id,
    if(interests != null) "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
    if(firstName != null)"first_name": firstName,
    if(email != null) "email": email,
    if(countryId != null)"country_id": countryId,
    if(cityId != null) "city_id": cityId,
  };
}

class Education {
  String? fieldId;
  String? endDate;
  String? universityId;
  String? degreeId;
  String? degreeName;
  String? universityName;
  String? fieldName;
  String? startDate;

  Education({
    this.fieldId,
    this.endDate,
    this.universityId,
    this.degreeId,
    this.degreeName,
    this.universityName,
    this.fieldName,
    this.startDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    fieldId: json["field_id"],
    endDate: json["end_date"],
    universityId: json["university_id"],
    degreeId: json["degree_id"],
    degreeName: json["degree_name"],
    universityName: json["university_name"],
    fieldName: json["field_name"],
    startDate: json["start_date"],
  );

  Map<String, dynamic> toJson() => {
    "field_id": fieldId,
    "end_date": endDate,
    "university_id": universityId,
    "degree_id": degreeId,
    "degree_name": degreeName,
    "university_name": universityName,
    "field_name": fieldName,
    "start_date": startDate,
  };
}

class Experience {
  String? name;
  String? numberOfYear;
  String? durationName;

  Experience({
    this.name,
    this.numberOfYear,
    this.durationName,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    name: json["name"],
    numberOfYear: json["number_of_year"],
    durationName: json["duration_name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "number_of_year": numberOfYear,
    "duration_name": durationName,
  };
}

class LicensesOrCertification {
  String? endDate;
  String? name;
  String? issuingOrganization;
  String? startDate;

  LicensesOrCertification({
    this.endDate,
    this.name,
    this.issuingOrganization,
    this.startDate,
  });

  factory LicensesOrCertification.fromJson(Map<String, dynamic> json) => LicensesOrCertification(
    endDate: json["end_date"],
    name: json["name"],
    issuingOrganization: json["issuing_organization"],
    startDate: json["start_date"],
  );

  Map<String, dynamic> toJson() => {
    "end_date": endDate,
    "name": name,
    "issuing_organization": issuingOrganization,
    "start_date": startDate,
  };
}
