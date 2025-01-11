import 'package:jelanco_tracking_system/models/basic_models/interested_party_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';

class GetArticlesOfInterestModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<InterestedPartyModel>? articlesOfInterest;

  GetArticlesOfInterestModel({
    this.status,
    this.pagination,
    this.articlesOfInterest,
  });

  factory GetArticlesOfInterestModel.fromMap(Map<String, dynamic> json) => GetArticlesOfInterestModel(
    status: json["status"],
    pagination: json["pagination"] == null ? null : PaginationModel.fromMap(json["pagination"]),
    articlesOfInterest: json["articles_of_interest"] == null ? [] : List<InterestedPartyModel>.from(json["articles_of_interest"]!.map((x) => InterestedPartyModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "pagination": pagination?.toMap(),
    "articles_of_interest": articlesOfInterest == null ? [] : List<dynamic>.from(articlesOfInterest!.map((x) => x.toMap())),
  };
}

