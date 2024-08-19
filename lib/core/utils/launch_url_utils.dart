import 'package:url_launcher/url_launcher.dart';

class LaunchUrlUtils {
  static void launchMyUrl({required storagePath, required String uriString}) async {
    final Uri uri = Uri.parse(storagePath + uriString);
    print('uri: ${uri}');
    if (!await launchUrl(uri)) {
      print('can\'t open the file');
    }
  }
}