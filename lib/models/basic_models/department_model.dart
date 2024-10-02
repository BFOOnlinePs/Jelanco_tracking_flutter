class DepartmentModel {
  final int? dId;
  final String? dName;

  DepartmentModel({
    this.dId,
    this.dName,
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> json) => DepartmentModel(
    dId: json["d_id"],
    dName: json["d_name"],
  );

  Map<String, dynamic> toMap() => {
    "d_id": dId,
    "d_name": dName,
  };
}