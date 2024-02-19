import 'educationModel.dart';
import 'experienceModel.dart';
import 'licensesOrCertificationModel.dart';

Map<String, dynamic> createUserData({
  String? firstName,
  String? lastName,
  String? ID,
  String? email,
  String? phoneNumber,
  String? dateOfBirth,
  String? countryId,
  String? cityId,
  String? password,
  List<Education>? education,
  List<String>? skills,
  Experience? experience,
  List<String>? interests,
  String? cvPath,
  List<LicensesOrCertification>? licensesOrCertifications,
}) {
  List<Map<String, dynamic>> educationList = education!.map((edu) => {
    'university_name': edu.universityName,
    'university_id': edu.universityId,
    'degree_id': edu.degreeId,
    'degree_name': edu.degreeName,
    'field_id': edu.fieldId,
    'field_name': edu.fieldName,
    'start_date': edu.startDate,
    'end_date': edu.endDate,
  }).toList();

  return {
    'first_name': firstName,
    'last_name': lastName,
    'ID': ID,
    'email': email,
    'phone_number': phoneNumber,
    'date_of_birth': dateOfBirth,
    'country_id': countryId,
    'city_id': cityId,
    'password': password,
    'education': educationList,
    'skills': skills,
    'experience': {
      'name': experience!.name,
      'number_of_year': experience.numberOfYear,
      'duration_name': experience.durationName,
    },
    'interests': interests,
    'cv_path': cvPath,
    'licenses_or_certifications': licensesOrCertifications!
        .map((LicensesOrCertification license) => {
      'name': license.name,
      'issuing_organization': license.issuingOrganization,
      'start_date': license.startDate,
      'end_date': license.endDate,
    })
        .toList(),
  };
}
