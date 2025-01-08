import 'package:jelanco_tracking_system/models/basic_models/interested_party_model.dart';

class GetInterestedPartiesModel {
  final bool? status;
  final List<InterestedPartyModel>? interestedParties;

  GetInterestedPartiesModel({
    this.status,
    this.interestedParties,
  });

  factory GetInterestedPartiesModel.fromMap(Map<String, dynamic> json) => GetInterestedPartiesModel(
    status: json["status"],
    interestedParties: json["interested_parties"] == null ? [] : List<InterestedPartyModel>.from(json["interested_parties"]!.map((x) => InterestedPartyModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "interested_parties": interestedParties == null ? [] : List<dynamic>.from(interestedParties!.map((x) => x.toMap())),
  };
}