import 'package:url_launcher/url_launcher.dart';

class LaunchUrlUtils {
  static void launchMyUrl(
      {required storagePath, required String uriString}) async {
    final Uri uri = Uri.parse(storagePath + uriString);
    print('uri: $uri');
    if (!await launchUrl(uri)) {
      print('can\'t open the file');
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  static Future<void> sendWhatsAppMessage(
    String phoneNumber,
    // String message,
  ) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
      // query: 'text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}
