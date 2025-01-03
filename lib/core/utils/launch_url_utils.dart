import 'package:url_launcher/url_launcher.dart';

class LaunchUrlUtils {
  static void launchMyUrl({required storagePath, required String uriString}) async {
    final Uri uri = Uri.parse(storagePath + uriString);
    print('uri: $uri');

    // if (!await launchUrl(uri)) {
    //   print('can\'t open the file');
    // }

    try {
      if (await canLaunchUrl(uri)) {
        print('Launching URL...');
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Could not launch $uri');
        throw 'Could not launch $uri';
      }
    } catch (e) {
      print('Error launching URL: $e');
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
    // add +972 to phone, and remove the 0 at the beginning
    phoneNumber = '+972${phoneNumber.substring(1)}';
    print('phoneNumber: $phoneNumber');
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
