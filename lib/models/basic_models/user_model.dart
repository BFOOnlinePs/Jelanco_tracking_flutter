import 'package:jelanco_tracking_system/models/basic_models/department_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/role_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  String? image;
  final String? jobTitle;
  final String? departments;
  final String? phoneNumber;
  String? userStatus;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<DepartmentModel>? userDepartments;
  List<RoleModel>? roles;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.jobTitle,
    this.departments,
    this.phoneNumber,
    this.userStatus,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.userDepartments,
    this.roles,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        jobTitle: json["job_title"],
        departments: json["departments"],
        phoneNumber: json["phone_number"],
        userStatus: json["user_status"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userDepartments: json["user_departments"] == null
            ? []
            : List<DepartmentModel>.from(json["user_departments"]!.map((x) => DepartmentModel.fromMap(x))),
        roles: json["roles"] == null ? [] : List<RoleModel>.from(json["roles"]!.map((x) => RoleModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "job_title": jobTitle,
        "departments": departments,
        "phone_number": phoneNumber,
        "user_status": userStatus,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user_departments": userDepartments == null ? [] : List<dynamic>.from(userDepartments!.map((x) => x.toMap())),
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toMap())),
      };
}
