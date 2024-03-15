import 'opportunityModel.dart';

class SavedOpportunity {
  String id;
  String user_id;
  String opportunity_id;
  Opportunity? opportunity;
  SavedOpportunity({
    required this.id,
    required this.user_id,
    required this.opportunity_id,
    this.opportunity,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': id,
      'user_id': user_id,
      'opportunity_id': opportunity_id,
      'opportunity': opportunity,
    };
  }
}