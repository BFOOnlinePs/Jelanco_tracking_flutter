
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class FormatUtils {
  // this format: "["2000", "2020"]" || [الخليل, القدس, رام الله]
  // return string
  static String citiesNamesFormat(String? list) {
    if (list == null) return '';
    String? str =
    list.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').replaceAll(',', ' | ');

    return str;
  }

  // returns this format: ["1","2","3"]
  static String formatUsersList(List<UserModel?> usersList) {
    if (usersList.isEmpty) {
      return '';
    }
    return '[${usersList.map((user) => '"${user?.id}"').join(",")}]';
  }
}