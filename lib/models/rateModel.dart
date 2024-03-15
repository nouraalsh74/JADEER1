// To parse this JSON data, do
//
//     final rate = rateFromJson(jsonString);

import 'dart:convert';

Rate rateFromJson(String str) => Rate.fromJson(json.decode(str));

String rateToJson(Rate data) => json.encode(data.toJson());

class Rate {
  Rate({
    this.uid,
    this.rate,
    this.rateId,
    this.opportunityId,
  });

  String? uid;
  String? rate;
  String? rateId;
  String? opportunityId;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
    uid: json["UID"],
    rate: json["rate"],
    rateId: json["rateID"],
    opportunityId: json["opportunity_id"],
  );

  Map<String, dynamic> toJson() => {
    "UID": uid,
    "rate": rate,
    "rateID": rateId,
    "opportunity_id": opportunityId,
  };
}
