// To parse this JSON data, do
//
//     final getAllPermissionsModel = getAllPermissionsModelFromMap(jsonString);

import 'dart:convert';

import '../basic_models/permission_model.dart';


List<PermissionModel> getAllPermissionsModelFromMap(String str) => List<PermissionModel>.from(json.decode(str).map((x) => PermissionModel.fromMap(x)));

String getAllPermissionsModelToMap(List<PermissionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

