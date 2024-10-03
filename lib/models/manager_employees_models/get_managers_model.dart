import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class GetManagersModel {
  final bool? status;
  final List<UserModel>? managers;

  GetManagersModel({
    this.status,
    this.managers,
  });

  factory GetManagersModel.fromMap(Map<String, dynamic> json) => GetManagersModel(
    status: json["status"],
    managers: json["managers"] == null ? [] : List<UserModel>.from(json["managers"]!.map((x) => UserModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "managers": managers == null ? [] : List<dynamic>.from(managers!.map((x) => x.toMap())),
  };
}

