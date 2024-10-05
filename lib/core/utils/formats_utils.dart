

class FormatUtils {
  // this format: "["2000", "2020"]" || [الخليل, القدس, رام الله]
  // return string
  static String formJsonToString(String? list) {
    if (list == null) return '';
    String? str =
    list.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').replaceAll(',', ' | ');

    return str;
  }

  // returns this format: ["1","2","3"]
  // static String formatUsersList(List<UserModel?> usersList, ) {
  //   if (usersList.isEmpty) {
  //     return '';
  //   }
  //   return '[${usersList.map((user) => '"${user?.id}"').join(",")}]';
  // }

  // returns this format: ["1","2","3"]

  static String formatList<T>(List<T?> list, String? Function(T?) getId) {
    if (list.isEmpty) {
      return '';
    }
    return '[${list.map((item) => '"${getId(item)}"').join(",")}]';
  }


  static bool checkIfNumberInList(String stringList, int number) {
    // Convert the string format into a list of integers
    List<int> intList = (stringList.replaceAll(RegExp(r'[\[\]"]'), '').split(','))
        .map((e) => int.parse(e.trim()))
        .toList();

    // Check if the number is in the list
    return intList.contains(number);
  }
}