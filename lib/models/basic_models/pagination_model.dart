class PaginationModel {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? totalItems;

  PaginationModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.totalItems,
  });

  factory PaginationModel.fromMap(Map<String, dynamic> json) => PaginationModel(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    totalItems: json["total_items"],
  );

  Map<String, dynamic> toMap() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total_items": totalItems,
  };
}
